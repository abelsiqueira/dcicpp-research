#!/bin/bash

# Everything will have 'nozero' and 'nofix' implicit (except var)

dir=special_lists
rm -rf $dir
mkdir $dir

cp lists/{nozero_nofix_var1e*,notunc,cholok,nozero.time}.list $dir
cd $dir

sil=sif-intersect-lists.sh
$sil cholok.list nozero.time.list > nozero_cholok_nofix.list
$sil notunc.list nozero_cholok_nofix.list > nozero_cholok_nofix_notunc.list

for slack in true false
do
  cat nozero_nofix_var1e{0,2}*${slack}.list > nozero_small_medium_slack${slack}.list
  cat nozero_nofix_var1e2*${slack}.list > nozero_medium_slack${slack}.list
  $sil nozero_small_medium_slack${slack}.list cholok.list > nozero_cholok_small_medium_slack${slack}.list
  $sil nozero_medium_slack${slack}.list cholok.list > nozero_cholok_medium_slack${slack}.list
done
