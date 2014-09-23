#!/bin/bash

[ -z "$1" ] && echo "Needs list" && exit 1
list=$1

maxvar=10
maxcon=10

tmpdir=$(mktemp -d)
cp $list $tmpdir/
list=$(basename $list)
cd $tmpdir
for problem in $(cat $list)
do
  runcutest -p genc -D $problem > out
  nvar=$(awk '/# variables/ {print $4}' out)
  ncon=$(awk '/# constraints  / {print $4}' out)

  if [ $nvar -lt $maxvar -a $ncon -lt $maxcon ]
  then
    echo $problem $nvar $ncon
  fi
done
