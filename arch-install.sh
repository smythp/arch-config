parted /dev/sda

# in parted:

mklabel msdos
mkpart primary ext4 1MiB 200GiB
set 1 boot on
mkpart primary linux-swap 200GiB 208GiB
mkpart primary ext4 208GiB 308GiB
mkpart primary ext4 308GiB 408GiB

mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2

# install base packages

pacstrap -i /mnt base base-devel

# enter the new install
arch-chroot /mnt /bin/bash

# isntall emacs again
pacman -S community/emacs

emacs /etc/locale.gen
# uncomment line with en_US.UTF-8 UTF-8


locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

tzselect
ln -s /usr/share/zoneinfo/America/New_York > /etc/localtim
hwclock --systohc --utc

pacman -S grub os-prober
grub-install --recheck --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo patrick > /etc/hostname
passwd

# allow wired connections
systemctl enable dhcpcd@enp0s25.service


# audio

# run as server
jackd -r -m -p 8 -d dummy

# use
