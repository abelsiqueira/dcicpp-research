#!/bin/bash

tmpdir=$(mktemp -d)
cp dcicpp.spc $tmpdir

# Ensure that print_A_at_end is 1
[ -z "$(grep "print_A_at_end 1" dcicpp.spc)" ] &&\
  echo "Add 'print_A_at_end 1' to dcicpp.spc" && exit 1

# Ensure that verbositiy_level is 0
vblevel=$(grep "verbosity_level\s\+0" dcicpp.spc)
[ -z "$vblevel" ] && echo "Set verbosity_level to 0 in dcicpp.spc" && exit 1

problem=$1
[ -z "$problem" ] && echo "Need problem" && exit 1

cd $tmpdir
rundcicpp -D $problem | grep "[];]" > mtx.m
octave -q --eval "mtx; cond(A)"

