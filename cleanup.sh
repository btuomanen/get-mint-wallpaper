rm -rf "${HOME}/temp0"

rm -rf "${HOME}/mint-backgrounds"

if [ -e "${HOME}/backgrounds" ] && [ -d "${HOME}/backgrounds"] ; then
for fn in ${HOME}/backgrounds/* ; do
        if [ ! ${fn: -3} == "deb" ] ; then 
            rm -rf $fn
        fi
    done
fi

