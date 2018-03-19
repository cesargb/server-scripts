#!/usr/bin/env bash

set -o pipefail

if [ $EUID != 0 ]; then
    echo "Please run as root"
    exit 2
fi

if [ $(which yum) ];then
    PACKAGES=`yum -q check-update | grep -v "^$" | awk '{print $1}'`

    if [ $? != 0]; then
        echo "yum check update fail"
        exit $?
    fi
elif [ $(which apt-get) ];then
    apt-get update >/dev/null

    if [ $? != 0]; then
        echo "apt-get check update fail"
        exit $?
    fi

    PACKAGES=`apt-get -s upgrade | grep "^Inst" | awk '{print $2}'`

    if [ $? != 0]; then
        echo "apt-get check update fail"
        exit $?
    fi
else
    echo "This system can not be analyzed"
    exit 2
fi

fi [ "$PACKAGES" ]; then
    exit 0
else
    echo "$PACKAGES"
    exit 1
fi
