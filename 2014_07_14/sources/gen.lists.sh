#!/bin/bash

slack="false"

for dir in $(ls | grep compare)
do
  if [ -f $dir/cutest.algencan ]; then
    awk '{if ($3 <= 0.005) print $1}' $dir/cutest.algencan > /tmp/toosmall.list
  else
    echo "" > /tmp/toosmall.list
  fi
  sif-invert-list.sh /tmp/toosmall.list > $dir/lists/set.list
  grep cholok $dir/cutest.dcicpp | awk '{print $1}' > /tmp/fullrank.list
  cat backup.lists/var1e{0,2}*_con1e{0,2}*${slack}.list > /tmp/nolarge.list
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
