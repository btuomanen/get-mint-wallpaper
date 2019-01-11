#!/bin/bash

# Linux Mint Wallpaper Retriever

# This is to facilitate the easy download of Linux mint backgrounds for Windows 10 users.
# (Mint has pretty good backgrounds, if you didn't know)

# This assumes you have WSL installed.  Usage:

# source get-mind-wallpaper.sh

# this was written in WSL, to automate getting the nice Linux Mint backgrounds
# for use in Windows.  Puts these in a "mint-backgrounds" directory, opens them in explorer at the end.

# (this is mostly meant as a review for my GNU/Linux Bash scripting, it's nothing special.)


# BTW this assumes that your WSL username is the same as your Windows username!!!

if [ ! -d "${HOME}/backgrounds" ]; then
    mkdir "${HOME}/backgrounds"
fi

cd "${HOME}/backgrounds"


# get a few other backgrounds from the net
# as desired here...

# figure out some way to automate downloading these background deb files from here:
# http://packages.linuxmint.com/pool/main/m/

wget -c "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-nadia/mint-backgrounds-nadia_1.4_all.deb"
wget -c "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-maya-extra/mint-backgrounds-maya-extra_1.1_all.deb"
wget -c "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-nadia-extra/mint-backgrounds-nadia-extra_1.0_all.deb"

if [ -d "${HOME}/temp0" ]; then
    rm -rf "${HOME}/temp0"
fi

mkdir "${HOME}/temp0"


if [ -d "${HOME}/mint-backgrounds" ]; then
    rm -rf "${HOME}/mint-backgrounds"
fi

mkdir "${HOME}/mint-backgrounds"


export index0="0"

cd "${HOME}/temp0"

for fn in "${HOME}/backgrounds/"* ; do
        #echo "fn : ${fn} : done with fn."
        if [ ! -d $fn ]; then  
        if [ ${fn: -3} == "deb" ]; then
            # data can be stored in deb files as xz or gz.... be sure to check here.
            if ar t $fn | grep -q "data.tar.xz" ; then 
                ar x $fn data.tar.xz
                xz -d data.tar.xz
            elif ar t $fn | grep -q "data.tar.gz" ; then
                ar x $fn data.tar.gz
                gunzip data.tar.gz
            fi

            tar -xf ./data.tar "./usr/share/backgrounds"
            

            export index1=0

            for img in "./usr/share/backgrounds/"* ; do 
                mv "${img}" "${HOME}/mint-backgrounds/${index0}-${index1}"
                export index1=`expr $index1 + 1`
            done

            rm -rf *
            export index0=`expr $index0 + 1`


            fi
        fi
    done

cd $HOME
source ./cleanup.sh


export realdir="/mnt/c/Users/brtuoman/mint-backgrounds/" 

if [ ! -d $realdir ]; then
    mkdir $realdir
fi

cd "${HOME}/mint-backgrounds"
cp -r * "${realdir}"

echo "done extracting backgrounds."
explorer.exe "C:\\Users\\${USER}\\mint-backgrounds"
