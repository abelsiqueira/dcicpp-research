#!/bin/bash

newfile=$1
[ -z "$1" ] && newfile=cutest.dcicpp.new
oldfile=$2
[ -z "$2" ] && oldfile=cutest.dcicpp.old


[ ! -f $newfile ] && echo "File $newfile doest not exist" && exit 1
[ ! -f $oldfile ] && echo "File $oldfile doest not exist" && exit 1

file1=$oldfile
file2=$newfile
awk '{if ($1 == "#Name") next; if ($2 != "convergence") print $1}' \
  $file1 | sort -u | while read p; do g=$(grep -w $p $file2 | \
  grep convergence); [ -z "$g" ] || grep -w $p $file1 $file2; done > \
  passou_a_funcionar

file1=$newfile
file2=$oldfile
awk '{if ($1 == "#Name") next; if ($2 != "convergence") print $1}' \
  $file1 | sort -u | while read p; do g=$(grep -w $p $file2 | \
  grep convergence); [ -z "$g" ] || grep -w $p $file1 $file2; done > \
  deixou_de_funcionar

file1=$newfile
file2=$oldfile
awk '{if ($1 == "#Name") next; if ($2 != "convergence") print $1}' \
  $file1 | sort -u | while read p; do g=$(grep -w $p $file2 | \
  grep convergence); [ -z "$g" ] && grep -w $p $file1 $file2; done > \
  nunca_funcionou

file1=$newfile
file2=$oldfile
awk '{if ($1 == "#Name") next; if ($2 == "convergence") print $1}' \
  $file1 | sort -u | while read p; do g=$(grep -w $p $file2 | \
  grep convergence); [ -z "$g" ] || grep -w $p $file1 $file2; done > \
  sempre_funcionou

for i in passou_a_funcionar nunca_funcionou deixou_de_funcionar sempre_funcionou;
do
  sed 's/.*:\([^ ]*\) .*/\1/g' $i | sort -u > $i.list
done
for i in passou_a_funcionar nunca_funcionou deixou_de_funcionar
do
  ./get.from.size.sh $i.list > $i.sizes
done
