# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

```
yay -S git stow waybar rofi hyprpaper copyq swaync kitty nemo wlr-randr xdg-desktop-portal-hyprland-git hyprpolkitagent
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
