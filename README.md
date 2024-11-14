# My dotfiles

This directory contains the dotfiles for my system


## To Install Arch Linux With Hyprland

Please follow [ArchLinuxInstallation.md](./ARCH-INSTALLATION.md)

## Requirements

Ensure you have the following installed on your system

```
$ yay -S git stow waybar rofi-wayland hyprpaper copyq swaync kitty nemo wlr-randr xdg-desktop-portal-hyprland-git hyprpolkitagent pipewire pipewire-pulse lib32-pipewire pipewire-alsa alsa-utils wireplumber qt5-wayland qt6-wayland ttf-font-awesome waybar-module-pacman-updates-git btop mpd
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:OldemarJesus/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```

## Common Programs

Visual Studio Code
```
$ yay -S visual-studio-code-bin
```

JetBrains Rider
```
$ yay -S rider
```


ZenBrowser
```
$ yay -S zen-browser-avx2-bin
```

WebCord
```
$ yay -S webcord
```
