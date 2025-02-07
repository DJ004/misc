#!/bin/bash

targettemp=80 #degrees 
started=1

gmx mdrun -v -s PROD.tpr -deffnm TEST &

trap "kill COMMAND; exit" SIGINT SIGTERM

while true
do
  currenttemp=$(sensors -u | awk '/temp1_input/ {print $2; exit}' )
  compare=$(echo $currenttemp'>'$targettemp | bc -l)
  if [ "$compare" -eq 1 ] && [ "$started" -eq 1 ] 
  then
    started=0
    kill -STOP COMMAND
  fi
  if [ "$compare" -eq 0 ] && [ "$started" -eq 0 ]
  then
    started=1
    kill -CONT COMMAND
  fi
  sleep 1 & wait $!
done
