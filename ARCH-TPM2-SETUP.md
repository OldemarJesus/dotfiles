# ARCH TPM2 SETUP

1. Backup Current Setup

```
cryptsetup luksHeaderBackup /dev/sdX --header-backup-file /root/luks-header-backup.img
```

2. Generate a Key for LUKS

2.1 Create a new keyfile for unlockng LUKS

```
dd if=/dev/urandom of=/root/luks-keyfile bs=64 count=1
chmod 600 /root/luks-keyfile
```

2.2 Add this key to the LUKS slot

```
cryptsetup luksAddKey /dev/sdX /root/luks-keyfile

# test it 
cryptsetup open /dev/sdX cryptroot --key-file /root/luks-keyfile
```

3. Seal the Key in TPM

3.1 Use <code>tpm2-tools</code> to seal the keyfile into the TPM.

```
tpm2_nvdefine --index=0x1500016 --size=64 --attributes="policywrite|policyread|authread|authwrite"
tpm2_nvwrite --index=0x1500016 --input=/root/luks-keyfile

# verify the key was stored
tpm2_nvread --index=0x1500016
```

4. Modify Initramfs to Use TPM

4.1 Install <code>tpm2-tss</code>, <code>tpm2-tools</code>, and <code>clevis</code> packages.

```
sudo pacman -S tpm2-tss tpm2-tools clevis
```

4.2 Configure your initramfs to use the TPM to retrieve the key.

4.2.1 Add <code>tpm2</code> and <code>clevis</code> hooks to <code>/etc/mkinitcpio.conf</code>.

```
HOOKS=(... encrypt ... tpm2 clevis ...)
```

4.2.2 Regenerate the initramfs.

```
mkinitcpio -P
```

5. Configure GRUB

```
grub-mkconfig -o /boot/grub/grub.cfg
```

