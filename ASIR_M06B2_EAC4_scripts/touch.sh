#!/bin/bash

#login="amas"
start=1
end=$(date +%d)

for login in amas ppou mpou; do
    x=$start
    while [ $x -lt $end ];do
	    echo $login-2023120$x
	    touch -t 2023120"$x"1200 "/backups/$login-2023120$x.tgz"
    	(( x+=1 ))
    done
done
