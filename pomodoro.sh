#!/usr/bin/env sh

sleep $(( 3*1 )) #25*60 ))

MSG="!\n"
if [ "$(which zenity)" ]
then
    zenity --info --text="$MSG"
elif [ "$(which xmessage)" ]
then
    xmessage "$MSG"
else
    echo "$MSG"
fi
