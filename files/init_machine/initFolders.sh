#!/usr/bin/bash
mkdir -p ~/Applet
mkdir -p ~/Code
mkdir -p ~/bin
mkdir -p ~/Documents

for ((c=0; c<=5; c++))
do
    wget http://limengxun.com/files/Wallpapers/$c.jpg -o ~/Documents/Wallpapers/
done

ln -s ~/Code ~/Documents/Code
echo "initialized file structures"
