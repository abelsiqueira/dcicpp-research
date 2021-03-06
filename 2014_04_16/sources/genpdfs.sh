#!/bin/bash

cat > perprof.args << EOF
--tikz
--pdf
--semilog
--free-format
EOF

cat > empty.tex << EOF
\\documentclass[border={0 0.5cm 0cm 0.5cm}]{standalone}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}

\\begin{document}
EMPTY
\\end{document}
EOF
pdflatex -interaction batchmode -output-directory /tmp/ empty.tex

dates="2014.04.16"

suffix=(xf ov)
options=('' '--compare optimalvalues --infeasibility-tolerance 1e-4')

for date in $dates
do
  dir=compare.$date

  mkdir -p /tmp/$dir

  for n in 0 1
  do
    cmd="perprof @perprof.args $dir/cute* --success Optimal,Converged \
      --mintime 0.005 --maxtime 900 ${options[$n]}"
    name=all_${suffix[$n]}
    outname=$(echo $name.$date | tr . _).pdf

    $cmd -o /tmp/$dir/$name $*
    if [ -f /tmp/$dir/$name.pdf ]; then
      cp -f /tmp/$dir/$name.pdf ../plots/$outname
    else
      echo "Copying empty.pdf => $outname"
      cp -f /tmp/empty.pdf ../plots/$outname
    fi
    for list in $(ls $dir/lists/*.list)
    do
      name=${list/$dir\/lists\//}
      name=${name/.list/}_${suffix[$n]}
      outname=$(echo $name.$date | tr . _).pdf

      $cmd -o /tmp/$dir/$name $* --subset $list
      if [ -f /tmp/$dir/$name.pdf ]; then
        cp -f /tmp/$dir/$name.pdf ../plots/$outname
      else
        echo "Copying empty.pdf => $outname"
        cp -f /tmp/empty.pdf ../plots/$outname
      fi
    done
  done
done
