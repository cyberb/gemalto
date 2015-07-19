### GemaltoOS

Live CD wth gemalto smart card driver citrix client installed (Not ready)

### Citrix

https://help.ubuntu.com/community/CitrixICAClientHowTo

#### If oyu see "Cannot Load PC/SC library libpcsclite.so" message

[x64 only] Citrix is only available for for x32 so you need to install corresponding libpcsclite1 
```
sudo apt-get install libpcsclite1:i386
sudo ln -s /lib/i386-linux-gnu/libpcsclite.so.1.0.0 /lib/libpcsclite.so
```

### Firefox

PPA is back: https://launchpad.net/~arnaud-morin/+archive/ubuntu/gemalto
```
sudo add-apt-repository ppa:arnaud-morin/gemalto
sudo apt-get update
sudo apt-get install libgtop11dotnet0
```

3. Firefox Preferences -> Advanced -> Certificates -> Security Devices
4. Load Module filenam: /usr/lib/libgtop11dotnet.so.0

### If ppa is not available, here is some info:

1. Download https://github.com/cyberb/gemaltoos/releases/download/lib/libgtop11dotnet.so.0.0.0 to /usr/lib
2. Create link /usr/lib/libgtop11dotnet.so.0
3. Install the following tools:

libboost-filesystem1.54.0, libboost-serialization1.54.0, libboost-system1.54.0, libboost-thread1.54.0, libc6 (>= 2.14), libgcc1 (>= 1:4.1.1), libpcsclite1 (>= 1.3.3), libstdc++6 (>= 4.6), zlib1g (>= 1:1.1.4), libengine-pkcs11-openssl, opensc, pcscd, pcsc-tools, libccid
