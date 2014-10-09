#!/bin/bash

slack="false"
dirs=$(ls | grep compare)

[ -z "$1" ] && algencanfile=$dir/cutest.algencan || algencanfile=$1
for dir in $dirs
do
  if [ -f $algencanfile ]; then
    awk '{if ($3 <= 0.005) print $1}' $algencanfile > /tmp/toosmall.list
  else
    echo "No algencan file"
    echo "" > /tmp/toosmall.list
  fi
  sif-invert-list.sh /tmp/toosmall.list > $dir/lists/set.list
  if [ -f $dir/cutest.dcicpp ]; then
    grep cholok $dir/cutest.dcicpp | awk '{print $1}' > \
      $dir/lists/fullrank_all.list
  else
    file=$(ls $dir | grep cutest.dcicpp | xargs echo | awk '{print $1}')
    grep cholok $dir/$file | awk '{print $1}' > $dir/lists/fullrank_all.list
  fi
  cat backup.lists/var1e{0,2}*_con1e{0,2}*${slack}.list > \
    $dir/lists/nolarge_all.list
  cp $dir/lists/fullrank_all.list /tmp/fullrank.list
  cp $dir/lists/nolarge_all.list /tmp/nolarge.list
  sif-intersect-lists.sh $dir/lists/fullrank_all.list \
    $dir/lists/nolarge_all.list > $dir/lists/fullrank_nolarge_all.list
  cp backup.lists/nofix.list /tmp/nofix.list
  sif-invert-list.sh /tmp/nofix.list > /tmp/onlyfix.list
  for list in fullrank nolarge nofix onlyfix
  do
    sif-intersect-lists.sh /tmp/${list}.list $dir/lists/set.list > \
      $dir/lists/${list}.list
  done
  for list in nolarge nofix onlyfix
  do
    sif-intersect-lists.sh $dir/lists/{$list,fullrank}.list > \
      $dir/lists/fullrank_${list}.list
  done
  for list in nofix onlyfix
  do
    sif-intersect-lists.sh $dir/lists/{nolarge,$list}.list > \
      $dir/lists/nolarge_$list.list
    sif-intersect-lists.sh $dir/lists/{nolarge_$list,fullrank}.list > \
      $dir/lists/fullrank_nolarge_$list.list
  done
done
