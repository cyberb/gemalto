#!/bin/bash

DISTRO=kubuntu-14.04.1-desktop-amd64
ISO_FILE=$DISTRO.iso
ISO_URL=http://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/kubuntu/releases/14.04/release
IMAGE_FILE=$DISTRO.img
IMAGE_SIZE=2000
LOOP_DEVICE=/dev/loop0;

apt-get install -y syslinux mtools squashfs-tools

#
# Converting iso to usb image
#

mkdir -p temp

if [ ! -f temp/$ISO_FILE ]; then
  wget --progress=dot:mega $ISO_URL/$ISO_FILE -O temp/$ISO_FILE
fi

cp temp/$ISO_FILE $ISO_FILE

if losetup -a | grep $LOOP_DEVICE; then
  echo "/dev/loop0 is already setup, deleting ..."
  losetup -d $LOOP_DEVICE
fi

dd bs=1M count=$IMAGE_SIZE if=/dev/zero of=$IMAGE_FILE
parted -s $IMAGE_FILE mktable msdos
parted -s $IMAGE_FILE mkpart primary 0% 100%

if [ -d image ]; then
  echo "image dir exists, deleting ..."
  rm -rf image
fi

mkdir image
losetup $LOOP_DEVICE $IMAGE_FILE -o 1048576 --sizelimit 2096103424
mkfs.fat $LOOP_DEVICE
mount $LOOP_DEVICE image

if [ -d iso ]; then
  echo "iso dir exists, deleting ..."
  rm -rf iso
fi

mkdir iso
mount -o loop kubuntu-14.04.1-desktop-amd64.iso iso
cp -a iso/. image/
umount iso

syslinux -s $LOOP_DEVICE
mv image/isolinux image/syslinux
mv image/syslinux/isolinux.cfg image/syslinux/syslinux.cfg

#
# Adding gemalto drivers
#

cp image/casper/filesystem.squashfs .
unsquashfs filesystem.squashfs
cp /run/resolvconf/resolv.conf squashfs-root/run/resolvconf/resolv.conf
chroot squashfs-root sudo add-apt-repository ppa:gemaltocrypto/dotnet+2.2.0.1
chroot squashfs-root sudo apt-get install -y libgtop11dotnet0

#
# Setting up citrix client
#

#
# Adding Firefox support
#

umount image
losetup -d $LOOP_DEVICE
