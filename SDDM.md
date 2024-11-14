# SIMPLE DISPLAY MANAGER CONFIGURATION

## Set Background Image

```
# copy background image
$ sudo cp /home/oldemar/.config/background-images/image.jpg  /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/2.png

# make new default background image
$ sudo sed -i 's/Backgrounds\/1.png/Backgrounds\/2.png/g' /usr/share/sddm/themes/sddm-astronaut-theme/Themes/theme1.conf

# make default theme for sddm
$ sudo sed -i 's/Current=/Current=sddm-astronaut-theme/g' /usr/lib/sddm/sddm.conf.d/default.conf
```
