# QEMU

## Installation

```
yay -S qemu-full
```

## VM Creation Example

```
# create hard disk
mkdir -p $HOME/VirtualMachines/windows01/disk
cd $HOME/VirtualMachines/windows01/disk
qemu-img create -f qcow2 windows01_disk -o nocow=on 50G

# download windows server evaluation from
# https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
mkdir -p $HOME/VirtualMachines/windows01/media
mv $HOME/Downloads/SERVER_EVAL_x64FRE_en-us.iso $HOME/VirtualMachines/windows01/media/WindowsServerEvaluationx64.iso

# prepare to Installation
qemu-system-x86_64 -cdrom $HOME/VirtualMachines/windows01/media/WindowsServerEvaluationx64.iso -boot -order=d -drive file=$HOME/VirtualMachines/windows01/disk/windows01_disk,format=qcow2 -m 4G
```

## Login Via FREERDP

```
# xfreerdp /v:localhost:3389 /u:<servername>\\<password> /p:<password> /f
# Example
xfreerdp /v:localhost:3389 /u:WIN-J0RU68UQ67E\\<oldemar> /p:<password> /f
```
