#!/usr/bin/env bash

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

s_rnd()
{
    OUT=""
    for i in {2..108}
    do
        if [[ 0 == $(( $i % 5)) ]]
        then
            OUT="${OUT}\n"
        fi
        
        ONE="$(printf %3d ${i}):$(printf %-3d $(shuf -i 1-${i} -n 1))"
        OUT="${OUT} \t${ONE}"
    done
    echo "${OUT}"
}

i=0
while true
do   
    sleep $(( (20)*60 ))
    
    msg "i:$i\ntwenty!\n\n$(s_rnd)" &
    
    i=$(( $i+1 ))
done
