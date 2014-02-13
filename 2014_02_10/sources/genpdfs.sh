#!/bin/bash

cat > perprof.args << EOF
--tikz
--pdf
--semilog
--free-format
EOF

# 2014.02.10
dates="2014.02.10 2014.02.12"
for date in $dates
do
  dir=compare.$date
  mkdir -p /tmp/$dir

  name=all
  outname=$(echo $name.$date | tr . _).pdf

  perprof @perprof.args $dir/cute* -o /tmp/$dir/$name $* \
    --success "Optimal,Converged" 
  cp /tmp/$dir/$name.pdf ../$outname
  for list in $(ls $dir/lists/*.list)
  do
    name=${list/$dir\/lists\//}
    name=${name/.list/}
    outname=$(echo $name.$date | tr . _).pdf

    perprof @perprof.args $dir/cute* -o /tmp/$dir/$name $* \
      --success "Optimal,Converged" --subset $list
    cp /tmp/$dir/$name.pdf ../$outname
  done
done
