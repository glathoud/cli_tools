#!/usr/bin/env bash

MYNAME=$(basename $0)

# Inspired from:
# https://askubuntu.com/questions/61708/automatically-sleep-and-wake-up-at-specific-times

if [[ ($# -eq 1)  &&  ($1 -eq "-test") ]]
then
    DESIRED="-s 8" # to test, we sleep only 8 seconds

elif [[ ($# -eq 2)  &&  ($1 -eq "-til") ]]
then
    A=$(date +%s -d "today $2")
    NOW=$(date +%s)
    if (( $A < $NOW ))
    then
        A=$(date +%s -d "tomorrow $2")
    fi
    DESIRED_DATE="$A"
else
    DESIRED_DATE=$(date +%s -d "today 12:25")
fi
if [ "$DESIRED_DATE" ]
then
    DESIRED="-t $DESIRED_DATE"
fi

echo "$(basename $0): $DESIRED"

# -l assumes hardware clock set to local time
# -u assumes         ...           UTC   time
#
# to choose, see the output of timedatectl
RTC_IN_LOCAL=$(timedatectl | grep "RTC in local TZ" | cut -f2 -d ":" | sed -E 's/^\s+|\s+$//g')

if [ "${RTC_IN_LOCAL}" = "yes" ]
then
    RTCWAKE_OPT="-l"
else
    RTCWAKE_OPT="-u"
fi

# do it!
sudo pkill rtcwake
sudo rtcwake $RTCWAKE_OPT -m mem $DESIRED
sleep 2

if (( $(date +%s) < $DESIRED_DATE ))
then
    MSG="$MYNAME:\nWoke up earlier than expected!\n\nParent:\n$(ps --no-headers -o command $PPID)"
    echo $MSG >&2
    if [ $(which zenity) ]
    then
        zenity --info --text="$MSG"
    elif [ $(which xmessage) ]
    then
        xmessage "$MSG"
    fi
        
    exit 1
fi
