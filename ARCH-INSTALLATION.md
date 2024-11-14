# Setup Guide

## SSH

Enable sshd (should be done by default)

```
$ systemctl enable sshd
```

set a password for the current user

```
$ passwd
```

## Partitioning Data

Get the names of the blocks

```
$ lsblk
```

For both partition setups, you'll want to setup a table on your primary drive.

Assuming your disk is on <code>/dev/nvme0n1</code>

```
$ gdisk /dev/nvme0n1
```

Inside of gdisk, you can print the table using the `p` command.

To create a new partition use the `n` command. The below table shows 
the disk setup I have for my primary drive

| partition | first sector | last sector | code |
|-----------|--------------|-------------|------|
| 1         | default      | +512M       | ef00 |
| 2         | default      | +4G         | ef02 |
| 3         | default      | default     | 8309 |

As result, you should have tree (3) partition inside <code>/dev/nvme0n1</code>
```
/dev/nvme0n1p1 # efi
/dev/nvme0n1p2 # boot
/dev/nvme0n1p3 # lvm + btrfs
```

## Encryption

Load the encryption modules to be safe.

```
$ modprobe dm-crypt
$ modprobe dm-mod
```

Setting up encryption on our luks lvm partiton

```
$ cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme0n1p3
```

Enter in your password and **Keep it safe**. There is no "forgot password" here.

Mount the driver:

```
$ cryptsetup open /dev/nvme1n1p3 luks_lvm
```

## Volume setup

Create the volume and volume group

```
$ pvcreate /dev/mapper/luks_lvm

$ vgcreate arch /dev/mapper/luks_lvm
```

Create a volume for your swap space. A good size for this is your RAM size + 2GB.
In my case, 32GB of RAM + 2GB = 34G.

```
$ lvcreate -n swap -L 34G arch
```


### Single Disk
If you have a single disk, you can either have a single volume for your root 
and home, or two separate volumes.

#### Single volume

```
$ lvcreate -n root -l +100%FREE arch
```

## Filesystems

FAT32 on EFI partiton

```
$ mkfs.fat -F32 /dev/nvme0n1p1 
```

EXT4 on Boot partiton

```
$ mkfs.ext4 /dev/nvme0n1p2
```

BTRFS on root

```
$ mkfs.btrfs -L root /dev/mapper/arch-root
```

Setup swap device

```
$ mkswap /dev/mapper/arch-swap
```

## Mounting

Mount swap

```
$ swapon /dev/mapper/arch-swap
$ swapon -a
```

Mount root btrfs

```
$ mount /dev/mapper/arch-root /mnt
```

Create subvolumes

```
$ btrfs subvolume create /mnt/@
$ btrfs subvolume create /mnt/@/home
$ btrfs subvolume create /mnt/@/root
$ btrfs subvolume create /mnt/@/opt
$ btrfs subvolume create /mnt/@/srv
$ btrfs subvolume create /mnt/@/tmp
$ btrfs subvolume create /mnt/@/usr
$ btrfs subvolume create /mnt/@/usr/local
$ btrfs subvolume create /mnt/@/var
$ btrfs subvolume create /mnt/@/var/log
$ btrfs subvolume create /mnt/@/var/tmp
$ btrfs subvolume create /mnt/@/var/cache
$ btrfs subvolume create /mnt/@/var/spool
```

Create snapshots subvolumes

```
$ btrfs subvolume create /mnt/@/.snapshots
$ mkdir /mnt/@/.snapshots/1
$ btrfs subvolume create /mnt/@/.snapshots/1/snapshot
```

Crete first snapshot metadata

```
$ date +"%Y-%m-%d %H:%M:%S"
$ nano /mnt/@/.snapshots/1/info.xml
```

Example content of <code>info.xml</code> file
```
<?xml version="1.0"?>
<snapshot>
	<type>single</type>
	<num>1</num>
	<date>2024-10-26 09:46:00</date>
	<description>First Root Filesystem Created at Installation</description>
</snapshot>
```

Setting default root subvolumes
```
$ btrfs subvolume set-default $(btrfs subvolume list /mnt | grep "@/.snapshots/1/snapshot" | grep -oP '(?<=ID )[0-9]+') /mnt
```

Exepected result
```
$ btrfs subvolume get-default /mnt
ID 258 gen 12 top level 257 path @/.snapshots/1/snapshot
```

Enable BTRFS Quota
```
$ btrfs quota enable /mnt
$ btrfs qgroup create 1/0 /mnt
```

Disable compression for var subvolumes
```
$ chattr +C /mnt/@/var/cache
$ chattr +C /mnt/@/var/log
$ chattr +C /mnt/@/var/spool
$ chattr +C /mnt/@/var/tmp
```

Remount root to the correct subvolume

```
$ umount /mnt
$ mount -o compress=zstd /dev/mapper/arch-root /mnt
```

Expected result
```
$ mount | grep /mnt

/dev/nvme0n1p7 on /mnt type btrfs (rw,relatime,compress=zstd:3,ssd,space_cache,subvolid=258,subvol=/@/.snapshots/1/snapshot)
```

Mount the boot partiton

```
$ mount /dev/nvme0n1p2 /mnt/boot
```

Create the efi directory

```
$ mkdir /mnt/boot/efi
```

Mount the EFI directory

```
$ mount /dev/nvme0n1p1 /mnt/boot/efi
```

Mounting btrfs sobvolumes
```
$ mkdir /mnt/home
$ mkdir /mnt/root
$ mkdir /mnt/opt
$ mkdir /mnt/srv
$ mkdir /mnt/tmp
$ mkdir -p /mnt/usr/local
$ mkdir -p /mnt/var/log
$ mkdir /mnt/var/tmp
$ mkdir /mnt/var/cache
$ mkdir /mnt/var/spool
$ mkdir /mnt/.snapshots

$ mount /dev/mapper/arch-root -o subvol=@/home,compress=zstd /mnt/home
$ mount /dev/mapper/arch-root -o subvol=@/root,compress=zstd /mnt/root
$ mount /dev/mapper/arch-root -o subvol=@/opt,compress=zstd /mnt/opt
$ mount /dev/mapper/arch-root -o subvol=@/srv,compress=zstd /mnt/srv
$ mount /dev/mapper/arch-root -o subvol=@/tmp,compress=zstd /mnt/tmp
$ mount /dev/mapper/arch-root -o subvol=@/usr,compress=zstd /mnt/usr
$ mount /dev/mapper/arch-root -o subvol=@/usr/local,compress=zstd /mnt/usr/local
$ mount /dev/mapper/arch-root -o subvol=@/var,compress=zstd,nodatacow /mnt/var
$ mount /dev/mapper/arch-root -o subvol=@/var/log,compress=zstd,nodatacow /mnt/var/log
$ mount /dev/mapper/arch-root -o subvol=@/var/tmp,compress=zstd,nodatacow /mnt/var/tmp
$ mount /dev/mapper/arch-root -o subvol=@/var/cache,compress=zstd,nodatacow /mnt/var/cache
$ mount /dev/mapper/arch-root -o subvol=@/var/spool,compress=zstd,nodatacow /mnt/var/spool
$ mount /dev/mapper/arch-root -o subvol=@/.snapshots,compress=zstd /mnt/.snapshots
```

## Install arch

With base-devel

```
$ pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs neovim lvm2 intel-ucode btrfs-progs ntfs-3g sudo nano
```

Load the file table

```
$ genfstab -U -p /mnt > /mnt/etc/fstab
```

chroot into your installation

```
$ arch-chroot /mnt /bin/bash
```

## Configuring

### Decrypting volumes

Open up mkinitcpio.conf

```
$ nvim /etc/mkinitcpio.conf
```

add `encrypt` and `lvm2` into the hooks

```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems)
```

### Bootloader

Install grub and efibootmgr

```
$ pacman -S grub efibootmgr
```

Setup grub on efi partition

```
$ grub-install --efi-directory=/boot/efi  --target=x86_64-efi --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
```

obtain your lvm partition device UUID

```
$ blkid /dev/nvme0n1p3
```

Copy this to your clipboard

```
$ nvim /etc/default/grub
```

Add in the following kernel parameters

```
root=/dev/mapper/arch-root cryptdevice=UUID=<uuid>:luks_lvm
```

### Keyfile

```
$ mkdir /secure
```

Root keyfile
```
$ dd if=/dev/random of=/secure/root_keyfile.bin bs=512 count=8
```

Home keyfile if home partition exists

```
$ dd if=/dev/random of=/secure/home_keyfile.bin bs=512 count=8
```

Change permissions on these

```
$ chmod 000 /secure/*
```

Add to partitions

```
$ cryptsetup luksAddKey /dev/nvme0n1p3 /secure/root_keyfile.bin
# skip below if using single disk
$ cryptsetup luksAddKey /dev/nvme1n1p1 /secure/home_keyfile.bin
```

```
$ nvim /etc/mkinitcpio.conf
```

```
FILES=(/secure/root_keyfile.bin)
```

## Grub

Create grub config

```
$ grub-mkconfig -o /boot/grub/grub.cfg
$ grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
```

## Nvidia

Install NVIDIA driver

```
$ pacman -S nvidia-dkms nvidia-utils egl-wayland libva-nvidia-driver
```

Update mkinitcpio on <code>/etc/mkinitcpio.conf</code>

```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Create kernel options for NVIDIA
File on <code>/etc/modprobe.d/nvidia.conf</code>
```
options nvidia_drm modeset=1 fbdev=1
```

Reload bootloader

```
$ sudo mkinitcpio -P
$ grub-mkconfig -o /boot/grub/grub.cfg
$ grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
```
## System Configuration

### Timezone

```
$ ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
```

### NTP

```
$ nvim /etc/systemd/timesyncd.conf
```

Add in the NTP servers

```
[Time]
NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org 
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org
```

Enable timesyncd

```
# systemctl enable systemd-timesyncd.service
```

### Locale

```
$ nvim /etc/locale.gen
```

uncomment the UTF8 lang you want

```
en_US.UTF-8 UTF-8
```

```
$ locale-gen
```

```
$ nvim /etc/locale.conf
```

```
LANG=en_US.UTF-8
```


### hostname

enter it into your /etc/hostname file

```
$ nvim /etc/hostname
```

or 

```
$ echo "mymachine" > /etc/hostname
```

### Users

First secure the root user by setting a password

```
$ passwd
```

Then install the shell you want

```
$ pacman -S zsh
```

Add a new user as follows

```
$ useradd -m -G wheel -s /bin/zsh user
```

set the password on the user

```
$ passwd user
```

Add the wheel group to sudoers

```
$ EDITOR=nvim visudo
```

```
%wheel ALL=(ALL:ALL) ALL
```

### Network Connectivity

```
$ pacman -S networkmanager
$ systemctl enable NetworkManager

```
$ grub-mkconfig -o /boot/grub/grub.cfg
$ grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
```


## Reboot

```
$ exit
$ umount -R /mnt
$ reboot now
```

## Install Hyprland

**Yay is required for this step.

Dependencies
```
$ yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang hyprcursor hyprwayland-scanner xcb-util-errors hyprutils-git
```

Clone repo (Using CMake)
```
$ git clone --recursive https://github.com/hyprwm/Hyprland
$ cd Hyprland
$ make all && sudo make install
```

Install Display Manager
```
$ yay -S sddm-git sddm-astronaut-theme
$ sudo systemctl enable sddm
```

## Secure Boot

Install sbctl

```
pacman -S sbctl
```

Now, you should reboot into bios and enable "Setup Mode" in Secure Boot".

Create keys and signing bootloader filesystems

```
$ sbctl create-keys
$ sbctl enroll-keys -m
$ sbctl sign -s /boot/efi/EFI/GRUB/grubx64.efi
$ sbctl sign -s /boot/efi/EFI/arch/grubx64.efi
$ sbctl sign -s /boot/vmlinuz-linux
```

Update grub

```
$ grub-mkconfig -o /boot/grub/grub.cfg
$ grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
```

