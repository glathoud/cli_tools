#!/usr/bin/env bash

# Inspired from:
# https://askubuntu.com/questions/61708/automatically-sleep-and-wake-up-at-specific-times

if [[ ($# -eq 1)  &&  ($1 -eq "-test") ]]
then
    DESIRED="-s 8" # to test, we sleep only 8 seconds
else
    DESIRED="-t "$(date +%s -d "today 12:25")
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
sudo rtcwake $RTCWAKE_OPT -m mem $DESIRED
sleep 2
