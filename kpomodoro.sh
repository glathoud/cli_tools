#!/usr/bin/env bash

nmax=100
while (( nmax-- )); do
    CURRENT=`ps axo pid,command | grep -E '\bpomodoro\b'`
    [ "$CURRENT" ] || break
    
    PID=`echo $CURRENT | cut -d ' ' -f 1`
    echo "About to kill: ${PID}"
    kill $PID

    if [ "$PID_LIST" ]; then
        PID_LIST="${PID_LIST},"
    fi
    PID_LIST="${PID_LIST}${PID}"
done

if [ "$PID_LIST" ]
then
    PID_LIST=" (${PID_LIST})"
else
    NOT="NOT "
fi
    
MSG="pomodoro was ${NOT}running${PID_LIST}"
if [ "`which zenity`" ]
then
    zenity --info --text="${MSG}"
elif [ "`which xmessage`" ]
then
    xmessage "${MSG}"
fi

echo "${MSG}"

if [ "$NOT" ]; then exit 1; fi
