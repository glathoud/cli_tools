#!/usr/bin/env bash

# (1) try to lock the screen
# (2) put the computer to sleep for a while, through `rtcwake`

MYNAME=$(basename $0)

# Inspired from:
# https://askubuntu.com/questions/61708/automatically-sleep-and-wake-up-at-specific-times

### Read the options

if [[ ($# -eq 1)  &&  ($1 == "-test") ]]
then
    DESIRED="-s 8" # to test, we sleep only 8 seconds

elif [[ ($# -eq 2)  &&  ($1 == "-til") ]]
then
    A=$(date +%s -d "today $2")
    NOW=$(date +%s)
    if (( $A < $NOW ))
    then
        A=$(date +%s -d "tomorrow $2")
    fi
    DESIRED_DATE="$A"

elif [[ ($# -eq 3)  &&  ($1 == "-fromto") ]]
     # -fromto <date_from> <date_to>
     # 
     # Example:
     # -fromto 16:00 17:00
     #
     # IFF <date_now> between <date_from> and <date_to>, THEN sleep
     # til <date_to>
then
    A=$(date +%s -d "today $2")
    B=$(date +%s -d "today $3")
    if (( $B < $A ))
    then
        B=$(date +%s -d "tomorrow $3")
    fi
    
    NOW=$(date +%s)
    if (( $A < $NOW ))
    then
        if (( $NOW < $B ))
        then
            DESIRED_DATE="$B"
        else
            exit 0  # no need to sleep
        fi
    fi

elif [[ ($# -eq 3)  &&  ($1 == "-waitfromto") ]]
     # -waitfromto <date_from> <date_to>
     #
     # IFF <date_now> between <date_from> and <date_to>, THEN *wait*
     # til <date_to>
     # 
     # Example:
     # -waitfromto 16:00 17:00
     #
     # same logic as in -fromto, but here we don't do any true
     # siesta: we don't put the PC to sleep, we just wait using
     # the... "sleep" command.
then
    A=$(date +%s -d "today $2")
    B=$(date +%s -d "today $3")
    if (( $B < $A ))
    then
        B=$(date +%s -d "tomorrow $3")
    fi
    
    NOW=$(date +%s)
    if (( $A < $NOW ))
    then
        if (( $NOW < $B ))
        then
            sleep $(( $B - $NOW ))
        fi
    fi

    exit 0 # in any case, no true siesta here, at most just waiting
    
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
        echo "$MYNAME: You could add the following line to your .bashrc :" >&2
        echo "$MYNAME: if [ -z `pgrep light-locker` ]; then light-locker &>/dev/null & fi">&2
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
date #xxx
sleep 2
date #xxx

# try to refresh the clock
# https://askubuntu.com/questions/254826/how-to-force-a-clock-update-using-ntp
set -v
sudo service ntp stop
sudo ntpd -gq
sudo service ntp start
set +v
date #xxx

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
