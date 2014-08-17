#!/bin/bash

DISTRO=kubuntu-14.04.1-desktop-amd64
ISO_FILE=$DISTRO.iso
ISO_URL=http://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/kubuntu/releases/14.04/release
IMAGE_FILE=$DISTRO.img
IMAGE_SIZE=2000
LOOP_DEVICE=/dev/loop0;

apt-get install -y syslinux mtools

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
losetup /dev/loop0 $IMAGE_FILE -o 1048576 --sizelimit 2096103424
mkfs.ext4 /dev/loop0
mount /dev/loop0 image

if [ -d iso ]; then
  echo "iso dir exists, deleting ..."
  rm -rf iso
fi

mkdir iso
mount -o loop kubuntu-14.04.1-desktop-amd64.iso iso
cp -a iso/. image/
umount iso

mv image/isolinux image/syslinux
mv image/syslinux/isolinux.cfg image/syslinux/syslinux.cfg
umount image

