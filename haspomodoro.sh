#!/usr/bin/env sh

set -v
basename $0
CURRENT=`ps aux | grep -E '\bpomodoro.sh\b'`
if [ ! $CURRENT ]
then
    NOT="not "
fi

MSG="pomodoro is ${NOT}running"
if [ "`which zenity`" ]
then
    zenity --info --text="${MSG}"
elif [ "`which xmessage`" ]
then
    xmessage "${MSG}"
fi

echo "${MSG}"

if [ "$NOT" ]; then exit 1; fi
