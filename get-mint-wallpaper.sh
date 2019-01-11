#!/bin/bash

# Linux Mint Wallpaper Retriever

# This is to facilitate the easy download of Linux mint backgrounds for Windows 10 users.
# (Mint has pretty good backgrounds, if you didn't know)

# This assumes you have WSL with Linux PowerShell installed.  Usage:

# source get-mind-wallpaper.sh

# this was written in WSL, to automate getting the nice Linux Mint backgrounds
# for use in Windows.  Puts these in a "mint-backgrounds" directory, opens them in explorer at the end.

# (this is mostly meant as a review for my GNU/Linux Bash scripting, it's nothing special.)


# BTW this assumes that your WSL username is the same as your Windows username!!!

pushd=`pwd`

if [ ! -d "${HOME}/backgrounds" ]; then
    mkdir "${HOME}/backgrounds"
fi



# get a few other backgrounds from the net
# as desired here...

# use Powershell script to download deb files.

pwsh "./retrieve-deb-files.ps1"

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
                cp -rf "${img}" "${HOME}/mint-backgrounds/"
                rm -rf "${img}"
                export index1=`expr $index1 + 1`
            done

            rm -rf *
            export index0=`expr $index0 + 1`


            fi
        fi
    done

cd $HOME


export realdir="/mnt/c/Users/${USER}/mint-backgrounds/" 

if [ -d $realdir ]; then
    rm -rf $realdir
fi

mkdir $realdir

cd "${HOME}/mint-backgrounds"

# iterate through all of the directories, moving jpgs to windows dir.
for dir in * ; do
    if [ -d $dir ]; then

        # should use some regex here to only send over jpg and png..
        for fn in "${dir}/"* ; do

                cp -rf $fn $realdir
                rm -rf $fn
        done
        #mv "${dir}/"*.jpg $realdir
    fi
done
#* "${realdir}"

#" source ./cleanup.sh

rm -rf "${HOME}/mint-backgrounds"
rm -rf "${HOME}/temp0"

echo "done extracting backgrounds."
explorer.exe "C:\\Users\\${USER}\\mint-backgrounds"
cd $pushd
