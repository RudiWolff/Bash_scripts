#!/bin/bash
for x in ppou amas mpou mfayos
do
	sudo userdel -rf $x 2> /dev/null
done
