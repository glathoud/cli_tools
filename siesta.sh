#!/usr/bin/env bash

# (1) try to lock the screen
# (2) put the computer to sleep for a while, through `rtcwake`

MYNAME=$(basename $0)

# Inspired from:
# https://askubuntu.com/questions/61708/automatically-sleep-and-wake-up-at-specific-times

### Read the options

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
    "$0" -test
    exit $?
fi
if [ "$DESIRED_DATE" ]
then
    DESIRED="-t $DESIRED_DATE"
fi

echo "$(basename $0): $DESIRED"

### Preparation

LIGHT_LOCKER="light-locker"
if [ "$(which $LIGHT_LOCKER)" ]
then
    # try to prepare for lock: guess who is having the xsession
    #
    # You have to run "light-locker" in the background with your X user
    # (could not find a better way from within sudo)
    #
    # Practically, you can add the following line at the end of your .bashrc:
    # if [ -z `pgrep light-locker` ]; then light-locker & fi
    LLPID=$( pgrep "$LIGHT_LOCKER" )
    if [ $LLPID ]
    then
        XUSER=$( ps -h -o user -fp $LLPID )
        if [ $XUSER ]
        then
            LIGHT_LOCKER_CMD=$(which "${LIGHT_LOCKER}-command")
        else
            echo "$MYNAME: Unexpected error trying to determine the X user"
            exit 1
        fi
    else
        echo "$MYNAME: Could not find a light-locker process => won't lock" >&2
        exit 1
    fi
fi

### make sure we are root, because of rtcwake after screen lock

if [ "root" != "$(whoami)" ]
then
    sudo $0 "$@"
    exit
fi

# Make sure we'll get root access before we (soon) lock the screen
sudo echo > /dev/null


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

# try to lock the screen
if [ "$LIGHT_LOCKER_CMD" ]
then
    su -c "$LIGHT_LOCKER_CMD -l" -l $XUSER
    sleep 3
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
