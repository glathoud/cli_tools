#!/usr/bin/env sh

if [ -z "$1" ]
then
    MSG="!"
else
    MSG="$1"
fi

if [ $(which zenity) ]
then
    zenity --info --text="$MSG"
elif [ $(which xmessage) ]
then
        xmessage "$MSG"
fi
