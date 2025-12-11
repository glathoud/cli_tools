#!/usr/bin/env sh

msg()
{
    MSG="$1"
    if [ "$(which zenity)" ]
    then
        zenity --info --text="$MSG"
    elif [ "$(which xmessage)" ]
    then
        xmessage -center "$MSG"
    else
        echo "$MSG"
    fi
}

i=0
while true
do   
    msg "i:$i\nzero!" &

    sleep $(( (21)*60 ))
    
    msg "i:$i\ntwenty-one!" &
    
    sleep $(( (21)*60 ))

    msg "i:$i\nforty-two - forty-nine!" &

    sleep $(( (7)*60 ))
    
    i=$(( $i+1 ))
done
