cd $HOME

rm -rf temp0

cd "${HOME}/backgrounds"

for fn in *
    do
        if [ ! ${fn: -3} == "deb" ]; 
            then rm $fn
        fi
    done

cd $HOME
