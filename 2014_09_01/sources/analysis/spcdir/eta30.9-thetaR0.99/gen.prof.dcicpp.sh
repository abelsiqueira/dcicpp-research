#!/bin/bash
#This should be used in the new folder, with the .out and table (2014-Jan-15)

file=cutest.dcicpp
list=$(ls *.list)

if [ "$(echo $list | wc -w)" -gt 1 ]; then
  echo "More than one list in this directory. Exiting"
  exit 1
fi

echo "#Name DCICPP-$(pwd|awk -F/ '{print $NF}')-$(date +"%d-%b-%Y") Problem Exit Time f |c| |gp| %8.6f" > $file

for problem in $(cat $list)
do
  exitflag=$(awk '/EXIT/ {print $5}' $problem.out)
  if [ ! -f $problem.out -o -z "$exitflag" ] 
  then
    exitflag=fail
    f=0
    c=0
    gp=0
    t=0
    texec=0
    tsetup=0
  else
    f=$(awk '/f\(x/ {print $3}' $problem.out)
    c=$(awk '/c\(x/ {print $3}' $problem.out)
    gp=$(awk '/g\(x/ {print $5}' $problem.out)
    texec=$(awk '/Execution/ {print $3}' $problem.out)
    tsetup=$(awk '/Setup/ {print $3}' $problem.out)
    t=$(awk '/Elapsed Time/ {print $4}' $problem.out)
  fi
  args="$problem $exitflag $t $f $c $gp"
  printf "%-10s %-10s %8.6e %+8.6e %+8.6e %+8.6e\n" $args >> $file
done 
