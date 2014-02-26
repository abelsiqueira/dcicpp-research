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

dates="2014.02.20"
for date in $dates
do
  dir=compare.$date
  mkdir -p /tmp/$dir

  name=all
  outname=$(echo $name.$date | tr . _).pdf

  perprof @perprof.args $dir/cute* -o /tmp/$dir/$name $* \
    --success "Optimal,Converged" 
  if [ -f /tmp/$dir/$name.pdf ]; then
    cp -f /tmp/$dir/$name.pdf ../$outname
  else
    echo "Copying empty.pdf => $outname"
    cp -f /tmp/empty.pdf ../$outname
  fi
  for list in $(ls $dir/lists/*.list)
  do
    name=${list/$dir\/lists\//}
    name=${name/.list/}
    outname=$(echo $name.$date | tr . _).pdf

    perprof @perprof.args $dir/cute* -o /tmp/$dir/$name $* \
      --success "Optimal,Converged" --subset $list
    if [ -f /tmp/$dir/$name.pdf ]; then
      cp -f /tmp/$dir/$name.pdf ../$outname 
    else
      echo "Copying empty.pdf => $outname"
      cp -f /tmp/empty.pdf ../$outname
    fi
  done
done
