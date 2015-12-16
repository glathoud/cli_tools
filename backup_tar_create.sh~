#!/usr/bin/env sh


if test "$1" != '-f'; then
    echo
    echo 'You may want to take this "backup" opportunity to check dead links first'
    echo 'find . -type l -exec test ! -e {} \; -print'
    echo
    echo "(use command-line option -f to skip this question)"
    echo -n "Do you want to continue (y/n)?"
    read answer
    if echo $answer | grep -viq "^y"; then
        echo "Aborted."
        exit
    fi
fi

sudo ls
find ./* -maxdepth 0 -exec tar zcf {}.tar.gz {} \; -exec sudo rm -rf {} \;
echo "Done."
