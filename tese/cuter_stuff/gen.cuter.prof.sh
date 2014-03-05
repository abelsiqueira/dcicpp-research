#!/bin/bash
tmpdir=$(mktemp -d)
args="--tikz --pdf --semilog -f cuter.*"
perprof $args -o $tmpdir/cuter_all
for i in equ ineq gencon unc
do
  perprof $args -o $tmpdir/cuter_${i} --subset=small.${i}.nofixed
done

for i in all equ ineq gencon unc
do
  cp $tmpdir/cuter_$i.pdf ../pdfimgs/
done
