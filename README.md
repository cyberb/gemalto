# Prepare

apt install libboost-filesystem libboost-serialization libboost-system1 libboost-thread1 libpcsclite1 libengine-pkcs11-openssl opensc pcscd pcsc-tools libccid

# Compile

```
./configure
make
```

# Install

```
make install
```

# Firefox

Preferences -> Advanced -> Certificates -> Security Devices
Load Module filenam: /usr/local/lib/libgtop11dotnet.so

