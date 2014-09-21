#!/bin/bash

list=$1
[ -z "$list" ] && echo "Need list" && exit 1

testdir=spcdir
rm -rf $testdir/*
mkdir -p $testdir

cp $list $testdir
cp dcicpp.spc $testdir
cd $testdir

for eta3 in 0.6 0.9
do
  for thetaR in 0.9 0.99
  do
    dir=eta3$eta3-thetaR$thetaR
    mkdir -p $dir
    awk -v eta3=$eta3 -v thetaR=$thetaR \
      '/eta3/ {print "eta3 ", eta3; next}; \
       /thetaR/ {print "thetaR ", thetaR; next}; \
       {print $0};' dcicpp.spc > $dir/dcicpp.spc
    cp $list $dir
    cp ../gen.prof.dcicpp.sh $dir
    cd $dir
    for problem in $(cat $list)
    do
      rundcicpp -D $problem > $problem.out
    done
    ./gen.prof.dcicpp.sh
    cd ..
  done
done

perprof eta*/cutest.dcicpp --tikz -o comparison --semilog --success Converged \
  --free-format
