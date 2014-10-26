#!/bin/bash

ISO_FILE_OUT=ubuntu-14.04.1-desktop-gemalto-amd64.iso
ISO_FILE=ubuntu-14.04.1-desktop-amd64.iso
ISO_URL=http://releases.ubuntu.com/14.04.1/$ISO_FILE
#IMAGE_FILE=$DISTRO.img
IMAGE_SIZE=2000
LOOP_DEVICE=/dev/loop0;

apt-get install -y squashfs-tools genisoimage

mkdir -p temp

if [ ! -f $ISO_FILE ]; then
  echo "downloading base image"
  wget --progress=dot:mega $ISO_URL/$ISO_FILE -O $ISO_FILE
fi

#echo "copying base image"
#cp temp/$ISO_FILE $ISO_FILE

if losetup -a | grep $LOOP_DEVICE; then
  echo "/dev/loop0 is already setup, deleting ..."
  losetup -d $LOOP_DEVICE
fi

mkdir -p mnt
mount -o loop $ISO_FILE mnt

mkdir -p extract-cd
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd

unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root edit
cp /etc/resolv.conf edit/etc/

mount --bind /dev/ edit/dev
chroot edit mount -t proc none /proc
chroot edit mount -t sysfs none /sys
chroot edit mount -t devpts none /dev/pts

chroot edit apt-get -y update
chroot edit add-apt-repository -y ppa:gemaltocrypto/dotnet+2.2.0.12
chroot edit apt-get update
chroot edit apt-get install -y libgtop11dotnet0

chroot edit umount /proc || umount -lf /proc
chroot edit umount /sys
chroot edit umount /dev/pts

umount edit/dev

chmod +w extract-cd/casper/filesystem.manifest
chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest
cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop

rm extract-cd/casper/filesystem.squashfs
mksquashfs edit extract-cd/casper/filesystem.squashfs

printf $(du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size

cd extract-cd
rm md5sum.txt
find -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat | tee md5sum.txt

mkisofs -D -r -V "GemaltoOS" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../$ISO_FILE_OUT .


#
# Adding gemalto drivers
#

#echo "installing gemalto driver"
#cp image/casper/filesystem.squashfs .
#rm -rf squashfs-root
#unsquashfs filesystem.squashfs
#cp /run/resolvconf/resolv.conf squashfs-root/run/resolvconf/resolv.conf
#chroot squashfs-root sudo add-apt-repository -y ppa:gemaltocrypto/dotnet+2.2.0.12
#chroot squashfs-root sudo apt-get update
#chroot squashfs-root sudo apt-get install -y libgtop11dotnet0

#
# Setting up citrix client
#

#
# Adding Firefox support
#

