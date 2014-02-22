#!/bin/bash

cat > perprof.args << EOF
--tikz
--pdf
--semilog
--free-format
EOF

cmd="perprof @perprof.args"
dates="2014.02.20"
for date in $dates
do
  dir=compare.$date
  mkdir -p /tmp/$dir

  name=all
  outname=$(echo $name.$date | tr . _).pdf

  $cmd $dir/cute* -o /tmp/$dir/$name $* \
    --success "Optimal,Converged" 
  cp /tmp/$dir/$name.pdf ../$outname
  for list in $(ls $dir/lists/*.list)
  do
    name=${list/$dir\/lists\//}
    name=${name/.list/}
    outname=$(echo $name.$date | tr . _).pdf

    $cmd $dir/cute* -o /tmp/$dir/$name $* \
      --success "Optimal,Converged" --subset $list
    cp /tmp/$dir/$name.pdf ../$outname
  done


  types="in exec setup"
  for t in $types
  do
    name=all.$t
    outname=$(echo $name.$date | tr . _).pdf

    $cmd $dir/cute*.$t -o /tmp/$dir/$name $* \
      --success "Optimal,Converged" 
    cp /tmp/$dir/$name.pdf ../$outname
    for list in $(ls $dir/lists/*.list)
    do
      name=${list/$dir\/lists\//}.$t
      name=${name/.list/}
      outname=$(echo $name.$date | tr . _).pdf

      $cmd $dir/cute*.$t -o /tmp/$dir/$name $* \
        --success "Optimal,Converged" --subset $list
      cp /tmp/$dir/$name.pdf ../$outname
    done
  done
done
