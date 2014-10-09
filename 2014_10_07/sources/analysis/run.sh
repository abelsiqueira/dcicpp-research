#!/bin/bash

[ -z "$1" ] && list=list || list=$1
[ ! -f $list ] && echo "File $list does not exist" && exit 1

[ -z "$2" ] && dcidir=$HOME/libraries/dcicpp || dcidir=$2
[ ! -d $dcidir ] && echo "DCI dir '$dcidir' is not correct" && exit 1

mkdir -p tmpdir
fullpath=$(pwd)/tmpdir

for br in old oldscale master
do
  mkdir -p $br
  ( cd $dcidir; git checkout $br; make purge cutest; make install PREFIX=$fullpath )
  for problem in $(cat list)
  do
    rundcicpp -Ltmpdir/lib -D $problem > \
      $br/$(echo $problem | tr [:upper:] [:lower:])
    mv ${problem}.tab $br/
  done
done

# Cleaning up
rm -f *.d *.f latex*
rm -rf tmp*
