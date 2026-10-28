// Renown Launcher: connects friends to the Renown realm (SPP Classics 1.12.1).
//   * reads its settings from launcher.json in the GitHub repository (address, ZeroTier network, news)
//   * checks that the login server answers, helps with ZeroTier if it doesn't
//   * keeps the RenownBar / Mangosbot addons and the client patch up to date
//   * writes the realmlist, clears the WoW cache when needed and starts WoW.exe
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Net.Sockets;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using System.Windows.Forms;

namespace RenownLauncher
{
    internal static class Program
    {
        public const string ConfigUrl = "https://raw.githubusercontent.com/RangerDanger96/spp-renown/main/launcher/launcher.json";

        [STAThread]
        private static void Main()
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }

    internal class RemoteConfig
    {
        public string serverName = "Renown Realm";
        public string address = "10.229.14.74";
        public int port = 3724;
        public string zerotierNetwork = "";
        public int cacheVersion = 1;
        public string clientFilesUrl = "";
        public string clientVersionUrl = "";
        public string news = "";
    }

    // Simple key=value settings in %APPDATA%\RenownLauncher\settings.ini
    internal class Settings
    {
        private readonly string path;
        private readonly Dictionary<string, string> values = new Dictionary<string, string>();

        public Settings()
        {
            string dir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "RenownLauncher");
            Directory.CreateDirectory(dir);
            path = Path.Combine(dir, "settings.ini");
            if (File.Exists(path))
            {
                foreach (string line in File.ReadAllLines(path))
                {
                    int eq = line.IndexOf('=');
                    if (eq > 0)
                    {
                        values[line.Substring(0, eq).Trim()] = line.Substring(eq + 1).Trim();
                    }
                }
            }
        }

        public string Get(string key, string fallback = "")
        {
            string v;
            return values.TryGetValue(key, out v) ? v : fallback;
        }

        public void Set(string key, string value)
        {
            values[key] = value ?? "";
            var sb = new StringBuilder();
            foreach (var kv in values)
            {
                sb.Append(kv.Key).Append('=').Append(kv.Value).AppendLine();
            }

            File.WriteAllText(path, sb.ToString());
        }
    }

    internal class MainForm : Form
    {
        private static readonly Color Back = Color.FromArgb(24, 20, 16);
        private static readonly Color Panel = Color.FromArgb(38, 32, 25);
        private static readonly Color Gold = Color.FromArgb(230, 180, 60);
        private static readonly Color Text = Color.FromArgb(235, 228, 210);
        private static readonly Color Dim = Color.FromArgb(160, 150, 130);
        private static readonly Color Good = Color.FromArgb(90, 200, 90);
        private static readonly Color Bad = Color.FromArgb(220, 70, 60);
        private static readonly Color Wait = Color.FromArgb(220, 170, 60);

        private readonly Settings settings = new Settings();
        private RemoteConfig config = new RemoteConfig();

        private readonly Label title = new Label();
        private readonly TextBox news = new TextBox();
        private readonly Label serverLight = new Label();
        private readonly Label serverText = new Label();
        private readonly Label ztLight = new Label();
        private readonly Label ztText = new Label();
        private readonly Button ztButton = new Button();
        private readonly TextBox wowPath = new TextBox();
        private readonly Button browse = new Button();
        private readonly Button play = new Button();
        private readonly Label status = new Label();
        private readonly Timer timer = new Timer();

        private bool serverUp;
        private bool busy;

        public MainForm()
        {
            Text = "Renown Launcher";
            ClientSize = new Size(640, 470);
            FormBorderStyle = FormBorderStyle.FixedSingle;
            MaximizeBox = false;
            StartPosition = FormStartPosition.CenterScreen;
            BackColor = Back;
            ForeColor = Text;
            Font = new Font("Segoe UI", 9.5f);
            try { Icon = Icon.ExtractAssociatedIcon(Application.ExecutablePath); } catch { }

            title.Text = "Renown Realm";
            title.Font = new Font("Georgia", 22f, FontStyle.Bold);
            title.ForeColor = Gold;
            title.SetBounds(20, 14, 600, 44);
            Controls.Add(title);

            var sub = new Label { Text = "World of Warcraft 1.12.1  -  Renown PvP", ForeColor = Dim };
            sub.SetBounds(22, 58, 600, 20);
            Controls.Add(sub);

            news.Multiline = true;
            news.ReadOnly = true;
            news.ScrollBars = ScrollBars.Vertical;
            news.BorderStyle = BorderStyle.None;
            news.BackColor = Panel;
            news.ForeColor = Text;
            news.SetBounds(20, 88, 600, 190);
            news.Text = "Loading news...";
            Controls.Add(news);

            // Status rows
            serverLight.SetBounds(20, 292, 14, 14);
            serverLight.BackColor = Wait;
            Controls.Add(serverLight);
            serverText.SetBounds(42, 288, 440, 22);
            serverText.Text = "Server: checking...";
            Controls.Add(serverText);

            ztLight.SetBounds(20, 322, 14, 14);
            ztLight.BackColor = Dim;
            Controls.Add(ztLight);
            ztText.SetBounds(42, 318, 440, 40);
            ztText.Text = "ZeroTier: -";
            ztText.ForeColor = Dim;
            Controls.Add(ztText);
            StyleButton(ztButton, false);
            ztButton.SetBounds(490, 314, 130, 28);
            ztButton.Visible = false;
            ztButton.Click += OnZeroTierButton;
            Controls.Add(ztButton);

            // WoW folder
            var wowLabel = new Label { Text = "WoW folder:", ForeColor = Dim };
            wowLabel.SetBounds(20, 366, 90, 22);
            Controls.Add(wowLabel);
            wowPath.SetBounds(110, 364, 400, 24);
            wowPath.BackColor = Panel;
            wowPath.ForeColor = Text;
            wowPath.BorderStyle = BorderStyle.FixedSingle;
            wowPath.ReadOnly = true;
            Controls.Add(wowPath);
            StyleButton(browse, false);
            browse.Text = "Browse...";
            browse.SetBounds(520, 362, 100, 28);
            browse.Click += OnBrowse;
            Controls.Add(browse);

            StyleButton(play, true);
            play.Text = "PLAY";
            play.Font = new Font("Georgia", 16f, FontStyle.Bold);
            play.SetBounds(460, 406, 160, 48);
            play.Click += OnPlay;
            Controls.Add(play);

            status.SetBounds(20, 420, 430, 40);
            status.ForeColor = Dim;
            Controls.Add(status);

            wowPath.Text = FindWowFolder();

            timer.Interval = 10000;
            timer.Tick += async (s, e) => await CheckServer();
            Shown += async (s, e) => await Startup();
        }

        private static void StyleButton(Button b, bool primary)
        {
            b.FlatStyle = FlatStyle.Flat;
            b.FlatAppearance.BorderColor = Gold;
            b.BackColor = primary ? Color.FromArgb(120, 80, 20) : Panel;
            b.ForeColor = primary ? Color.White : Text;
            b.Cursor = Cursors.Hand;
        }

        // ------------------------------------------------------------------ startup
        private async Task Startup()
        {
            await LoadConfig();
            await CheckServer();
            timer.Start();
        }

        private async Task LoadConfig()
        {
            try
            {
                string json;
                using (var web = new WebClient())
                {
                    web.Headers[HttpRequestHeader.CacheControl] = "no-cache";
                    json = await web.DownloadStringTaskAsync(Program.ConfigUrl + "?t=" + DateTime.UtcNow.Ticks);
                }

                config = new JavaScriptSerializer().Deserialize<RemoteConfig>(json) ?? new RemoteConfig();
                settings.Set("lastConfig", json.Replace("\r", "").Replace("\n", "\\n"));
            }
            catch
            {
                // offline or GitHub unreachable: use the last config we saw
                string cached = settings.Get("lastConfig");
                if (!string.IsNullOrEmpty(cached))
                {
                    try { config = new JavaScriptSerializer().Deserialize<RemoteConfig>(cached.Replace("\\n", "\n")); } catch { }
                }
            }

            title.Text = string.IsNullOrEmpty(config.serverName) ? "Renown Realm" : config.serverName;
            news.Text = (config.news ?? "").Replace("\n", Environment.NewLine);
            if (string.IsNullOrWhiteSpace(news.Text))
            {
                news.Text = "No news today.";
            }
        }

        // ------------------------------------------------------------------ server / ZeroTier status
        private async Task CheckServer()
        {
            if (busy)
            {
                return;
            }

            bool up = await Task.Run(() => CanConnect(config.address, config.port, 2500));
            serverUp = up;
            serverLight.BackColor = up ? Good : Bad;
            serverText.Text = up
                ? "Server: online (" + config.address + ")"
                : "Server: can't reach " + config.address + " - the host's PC may be off, or your connection isn't set up yet";
            UpdateZeroTier();
        }

        private static bool CanConnect(string host, int port, int timeoutMs)
        {
            try
            {
                using (var client = new TcpClient())
                {
                    var result = client.BeginConnect(host, port, null, null);
                    bool ok = result.AsyncWaitHandle.WaitOne(timeoutMs);
                    if (ok)
                    {
                        client.EndConnect(result);
                    }

                    return ok && client.Connected;
                }
            }
            catch
            {
                return false;
            }
        }

        private static string ZeroTierExe()
        {
            string p = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), @"ZeroTier\One\zerotier-one_x64.exe");
            if (File.Exists(p))
            {
                return p;
            }

            p = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), @"ZeroTier\One\zerotier-one_x86.exe");
            return File.Exists(p) ? p : null;
        }

        private static bool ZeroTierInstalled()
        {
            try
            {
                foreach (var s in ServiceController.GetServices())
                {
                    if (s.ServiceName.StartsWith("ZeroTier", StringComparison.OrdinalIgnoreCase))
                    {
                        return true;
                    }
                }
            }
            catch { }

            return ZeroTierExe() != null;
        }

        private static string ZeroTierNodeId()
        {
            try
            {
                string id = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), @"ZeroTier\One\identity.public");
                if (File.Exists(id))
                {
                    string text = File.ReadAllText(id);
                    int colon = text.IndexOf(':');
                    return colon > 0 ? text.Substring(0, colon) : null;
                }
            }
            catch { }

            return null;
        }

        private void UpdateZeroTier()
        {
            ztButton.Visible = false;
            if (string.IsNullOrEmpty(config.zerotierNetwork))
            {
                ztLight.BackColor = Dim;
                ztText.ForeColor = Dim;
                ztText.Text = "Direct connection (no ZeroTier needed)";
                return;
            }

            ztText.ForeColor = Text;
            if (!ZeroTierInstalled())
            {
                ztLight.BackColor = Bad;
                ztText.Text = "ZeroTier is not installed. Install it, then come back here.";
                ztButton.Text = "Get ZeroTier";
                ztButton.Tag = "install";
                ztButton.Visible = true;
                return;
            }

            string node = ZeroTierNodeId();
            if (serverUp)
            {
                ztLight.BackColor = Good;
                ztText.Text = "ZeroTier connected" + (node != null ? " (your ID: " + node + ")" : "");
                return;
            }

            ztLight.BackColor = Wait;
            ztText.Text = "Join the realm's network, then ask the host to approve you." + (node != null ? Environment.NewLine + "Your ZeroTier ID: " + node : "");
            ztButton.Text = "Join network";
            ztButton.Tag = "join";
            ztButton.Visible = true;
        }

        private void OnZeroTierButton(object sender, EventArgs e)
        {
            if ((string)ztButton.Tag == "install")
            {
                Process.Start("https://www.zerotier.com/download/");
                return;
            }

            string exe = ZeroTierExe();
            if (exe == null)
            {
                MessageBox.Show(this, "Couldn't find ZeroTier. Try reinstalling it.", "Renown Launcher");
                return;
            }

            try
            {
                // Joining a network needs administrator rights: Windows asks once
                var psi = new ProcessStartInfo(exe, "-q join " + config.zerotierNetwork) { Verb = "runas", UseShellExecute = true, WindowStyle = ProcessWindowStyle.Hidden };
                Process.Start(psi)?.WaitForExit(15000);
                string node = ZeroTierNodeId();
                MessageBox.Show(this,
                    "Join request sent." + Environment.NewLine + Environment.NewLine +
                    "Now ask the host to approve you on my.zerotier.com" + (node != null ? " (your ID: " + node + ")" : "") + "." + Environment.NewLine +
                    "The light turns green as soon as the server can be reached.",
                    "Renown Launcher");
            }
            catch (System.ComponentModel.Win32Exception)
            {
                // the user said no to the admin prompt
            }
        }

        // ------------------------------------------------------------------ WoW folder
        private string FindWowFolder()
        {
            string saved = settings.Get("wowPath");
            if (IsWowFolder(saved))
            {
                return saved;
            }

            string here = Path.GetDirectoryName(Application.ExecutablePath);
            if (IsWowFolder(here))
            {
                return here;
            }

            return "";
        }

        private static bool IsWowFolder(string folder)
        {
            return !string.IsNullOrEmpty(folder) && File.Exists(Path.Combine(folder, "WoW.exe"));
        }

        private void OnBrowse(object sender, EventArgs e)
        {
            using (var dlg = new FolderBrowserDialog { Description = "Pick your World of Warcraft 1.12.1 folder (the one with WoW.exe)" })
            {
                if (dlg.ShowDialog(this) == DialogResult.OK)
                {
                    if (IsWowFolder(dlg.SelectedPath))
                    {
                        wowPath.Text = dlg.SelectedPath;
                        settings.Set("wowPath", dlg.SelectedPath);
                    }
                    else
                    {
                        MessageBox.Show(this, "That folder doesn't contain WoW.exe.", "Renown Launcher");
                    }
                }
            }
        }

        // ------------------------------------------------------------------ play
        private async void OnPlay(object sender, EventArgs e)
        {
            string wow = wowPath.Text;
            if (!IsWowFolder(wow))
            {
                OnBrowse(sender, e);
                wow = wowPath.Text;
                if (!IsWowFolder(wow))
                {
                    return;
                }
            }

            busy = true;
            play.Enabled = false;
            try
            {
                SetStatus("Checking for updates...");
                await UpdateClientFiles(wow);

                SetStatus("Setting the realmlist...");
                WriteRealmlist(wow, config.address);
                ClearCacheIfNeeded(wow);

                if (!serverUp)
                {
                    var answer = MessageBox.Show(this, "The server isn't answering right now. Start WoW anyway?", "Renown Launcher", MessageBoxButtons.YesNo);
                    if (answer != DialogResult.Yes)
                    {
                        SetStatus("");
                        return;
                    }
                }

                SetStatus("Starting World of Warcraft...");
                Process.Start(new ProcessStartInfo(Path.Combine(wow, "WoW.exe")) { WorkingDirectory = wow, UseShellExecute = true });
                await Task.Delay(1500);
                WindowState = FormWindowState.Minimized;
                SetStatus("Have fun!");
            }
            catch (Exception ex)
            {
                SetStatus("Something went wrong: " + ex.Message);
            }
            finally
            {
                busy = false;
                play.Enabled = true;
            }
        }

        private void SetStatus(string text)
        {
            status.Text = text;
            status.Refresh();
        }

        private async Task UpdateClientFiles(string wow)
        {
            if (string.IsNullOrEmpty(config.clientVersionUrl) || string.IsNullOrEmpty(config.clientFilesUrl))
            {
                return;
            }

            string remote;
            try
            {
                using (var web = new WebClient())
                {
                    remote = (await web.DownloadStringTaskAsync(config.clientVersionUrl + "?t=" + DateTime.UtcNow.Ticks)).Trim();
                }
            }
            catch
            {
                return;   // offline: play with what we have
            }

            string key = "clientFiles:" + wow.ToLowerInvariant();
            if (remote == settings.Get(key))
            {
                return;
            }

            SetStatus("Downloading addons and patches...");
            string zip = Path.Combine(Path.GetTempPath(), "renown-client-files.zip");
            using (var web = new WebClient())
            {
                await web.DownloadFileTaskAsync(config.clientFilesUrl, zip);
            }

            SetStatus("Installing addons and patches...");
            await Task.Run(() =>
            {
                using (var archive = ZipFile.OpenRead(zip))
                {
                    foreach (var entry in archive.Entries)
                    {
                        if (string.IsNullOrEmpty(entry.Name))
                        {
                            continue;   // folder
                        }

                        string target = Path.GetFullPath(Path.Combine(wow, entry.FullName));
                        if (!target.StartsWith(Path.GetFullPath(wow), StringComparison.OrdinalIgnoreCase))
                        {
                            continue;   // never write outside the WoW folder
                        }

                        Directory.CreateDirectory(Path.GetDirectoryName(target));
                        entry.ExtractToFile(target, true);
                    }
                }
            });

            try { File.Delete(zip); } catch { }
            settings.Set(key, remote);
        }

        private static void WriteRealmlist(string wow, string address)
        {
            File.WriteAllText(Path.Combine(wow, "realmlist.wtf"), "set realmlist " + address + "\r\n");

            // Config.wtf can also hold a realmList; keep it in step
            string cfg = Path.Combine(wow, @"WTF\Config.wtf");
            if (File.Exists(cfg))
            {
                var lines = new List<string>(File.ReadAllLines(cfg));
                bool found = false;
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].StartsWith("SET realmList ", StringComparison.OrdinalIgnoreCase))
                    {
                        lines[i] = "SET realmList \"" + address + "\"";
                        found = true;
                    }
                    else if (lines[i].StartsWith("SET realmName ", StringComparison.OrdinalIgnoreCase))
                    {
                        lines.RemoveAt(i--);   // remembered realm from another server
                    }
                }

                if (!found)
                {
                    lines.Add("SET realmList \"" + address + "\"");
                }

                File.WriteAllLines(cfg, lines);
            }
        }

        private void ClearCacheIfNeeded(string wow)
        {
            string key = "cache:" + wow.ToLowerInvariant();
            string wanted = config.cacheVersion.ToString();
            if (settings.Get(key) == wanted)
            {
                return;
            }

            string wdb = Path.Combine(wow, "WDB");
            try
            {
                if (Directory.Exists(wdb))
                {
                    Directory.Delete(wdb, true);
                }
            }
            catch { }

            settings.Set(key, wanted);
        }
    }
}
