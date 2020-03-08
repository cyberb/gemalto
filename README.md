## Info

Gemalto .NET Library for smartcard 

Based on: https://launchpad.net/~arnaud-morin/+archive/ubuntu/gemalto/+packages

Latest fixes from: https://github.com/smartcardservices/smartcardservices/commit/3330c0cca77fc653c2fcc51749a26f49a49ed21b

## Prepare (Ubuntu)

apt install build-essential libboost-all-dev libpcsclite1 libengine-pkcs11-openssl opensc pcscd pcsc-tools libccid

## Compile

```
./configure
make
```

## Install

```
make install
```

## Firefox

Preferences -> Advanced -> Certificates -> Security Devices

Load Module: /usr/local/lib/libgtop11dotnet.so

