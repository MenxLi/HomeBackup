#!/usr/bin/bash
mkdir -p ~/Applet
mkdir -p ~/Code
mkdir -p ~/bin
mkdir -p ~/Documents
mkdir -p ~/Documents/Wallpapers
cd ~/Documents/Wallpapers

for (( c=0; c<=10; c++))
do
    wget http://limengxun.com/files/Wallpapers/$c.jpg
done

ln -s $HOME/Code ~/Documents/Code
echo "Created file structures."

