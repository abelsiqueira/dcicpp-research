#!/bin/bash

cats="in exec setup"
args="--semilog --tikz --pdf --free-format -f"
for category in $cats
do
  perprof $args --success "Converged" -o cmp_$category cutest.*.$category
done
