#!/bin/bash
if [[  "$(exec 3<>/dev/tcp/localhost/2181 ; echo -e "ruok\r\n" >&3 ; cat <&3)" == "imok" ]] ; then
    exit 0
else 
    exit 1
fi