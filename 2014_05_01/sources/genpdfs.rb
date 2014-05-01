#!/usr/bin/env ruby

open('perprof.args','w') do |file|
  file.puts('--tikz')
  file.puts('--semilog')
  file.puts('--free-format')
end

open('empty.tex','w') do |file|
  file.puts('\documentclass[border={0 0.5cm 0cm 0.5cm}]{standalone}')
  file.puts('\usepackage[utf8]{inputenc}')
  file.puts('\usepackage[T1]{fontenc}')
  file.puts('\begin{document}')
  file.puts('EMPTY')
  file.puts('\end{document}')
end

`pdflatex -interaction batchmode -output-directory /tmp/ empty.tex`

dirs=`find . -name "comp*"`.split
`mkdir -p ../plots`

suffixes=['xf', 'ov']
options=['', '--compare optimalvalues --infeasibility-tolerance 1e-4']

dirs.each do |dir|
  date = dir[/\.\/compare.(.*)/,1]

  lists = [''] + `ls #{dir}/lists/*.list`.split

  `mkdir -pv /tmp/#{dir}/`

  suffixes.each_with_index do |suffix,i|
    cmd = "perprof @perprof.args #{dir}/cute* --success Optimal,Converged" +
      " --mintime 0.005 --maxtime 900 #{options[i]}"

    lists.each_with_index do |list|
      if list == ''
        name = 'all'
        s = ''
      else
        name = list[/#{dir}\/lists\/(.*).list/,1]
        s = "--subset #{list}"
      end
      name = name + '_' + suffix + '_' + date
      name.gsub!('.','_')

      `#{cmd} -o /tmp/#{dir}/#{name} #{s}`
      if File.exist?("/tmp/#{dir}/#{name}.pdf")
        puts "Creating #{name}"
        `cp -f /tmp/#{dir}/#{name}.pdf ../plots/#{name}.pdf`
      else
        puts "Copying empty.pdf => #{name}"
        `cp -f /tmp/empty.pdf ../plots/#{name}.pdf`
      end
    end
  end
end
