#!/bin/bash

[ $# -lt 2 ] && echo "Precisa de dois argumentos: template e instructions" \
  && exit 1

template=$1
prefix=$2
instructions=$(mktemp)
cp $2 $instructions

for i in $template $instructions
do
  [ ! -f $i ] && echo "$i does not exists" && exit 1
done

plotnumber=0
filename=
while [ -s $instructions ]
do
  line=$(head -n1 $instructions)
  if [ ! -z "$(echo $line | grep NewPlot)" ]
  then
    if [ ! -z "$filename" ]
    then
      echo "\\end{tikzpicture}" >> $filename
      echo "\\end{document}" >> $filename
    fi
    plotnumber=$[$plotnumber+1]
    filename=${prefix}_img$plotnumber.tex
    cat $template > $filename
    echo "\\begin{document}" >> $filename
    echo "\\begin{tikzpicture}" >> $filename
  else
    [ -z "$filename" ] && echo "EMPTY filename" && exit 1
    echo $line >> $filename
  fi
  sed -i '1d' $instructions
done
echo "\\end{tikzpicture}" >> $filename
echo "\\end{document}" >> $filename

mkdir -p ${prefix}_plots
for i in $(seq $plotnumber)
do
  pdflatex --shell-escape --enable-write18 --halt-on-error ${prefix}_img$i.tex
  mv ${prefix}_img$i.pdf ${prefix}_plots/
done
