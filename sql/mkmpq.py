import ctypes, sys, os
L=ctypes.CDLL('/root/StormLib/build/libstorm.so')
H=ctypes.c_void_p
out=sys.argv[1]; files=sys.argv[2:]  # pairs local=archived
if os.path.exists(out): os.remove(out)
h=H()
assert L.SFileCreateArchive(out.encode(), 0x00100000|0x00000000, 16, ctypes.byref(h)), 'create'
for pair in files:
    local,arch=pair.split('=',1)
    ok=L.SFileAddFileEx(h, local.encode(), arch.encode(), 0x200|0x80000000, 0x02, 0x02)
    print('add',arch,bool(ok))
L.SFileCloseArchive(h)
# verify
h=H(); assert L.SFileOpenArchive(out.encode(),0,0x100,ctypes.byref(h))
for pair in files:
    local,arch=pair.split('=',1)
    f=H(); assert L.SFileOpenFileEx(h, arch.encode(), 0, ctypes.byref(f)), arch
    size=L.SFileGetFileSize(f,None); buf=ctypes.create_string_buffer(size); rd=ctypes.c_uint(0)
    L.SFileReadFile(f,buf,size,ctypes.byref(rd),None); L.SFileCloseFile(f)
    print('verify',arch, buf.raw[:rd.value]==open(local,'rb').read())
L.SFileCloseArchive(h)
