#!/usr/bin/env ruby

def create_samef_list(dir, ftol, f0)
  cmd = "./find-equal-fval.rb #{dir}/cute* --ftol #{ftol} --f0 #{f0}"
  samef = sprintf("samef_%1.0e_%1.0e", ftol, f0)
  sameflist = "#{dir}/lists/#{samef}.list"
  if File.exist?(sameflist)
    `mkdir $(dirname /tmp/#{sameflist}`
    `#{cmd} > /tmp/#{sameflist}`
    if `diff /tmp/#{sameflist} #{sameflist}`
      return
    end
    `mv -f /tmp/#{sameflist} #{sameflist}`
  else
    `#{cmd} > #{sameflist}`
  end
  lists = `ls #{dir}/lists/*.list`.split
  lists.each do |list|
    listname = list[/#{dir}.lists.(.*).list/,1]
    unless list.include?("samef")
      `sif-intersect-lists.sh #{list} #{sameflist} > #{dir}/lists/#{samef}_#{listname}.list`
    end
  end
end

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

dirs=`find . -name "comp*"`.split.sort
`mkdir -p ../plots`

#suffixes=['xf', 'ov']
#options=['', '--compare optimalvalues --infeasibility-tolerance 1e-4']
suffixes=['xf']
options=['']

ftols = [1e-3, 5e-3, 1e-2, 5e-2, 5e-1]
f0s = [1e-6, 1e-5, 1e-4]

dirs.each do |dir|
  `rm -f #{dir}/lists/samef_*`
  ftols.each do |ftol|
    f0s.each do |f0|
      create_samef_list(dir, ftol, f0)
    end
  end

  date = dir[/\.\/compare.(.*)/,1]

  lists = [''] + `ls #{dir}/lists/*.list`.split

  `mkdir -pv /tmp/#{dir}/`

  suffixes.each_with_index do |suffix,i|
    cmd = "perprof @perprof.args #{dir}/cute* --success Optimal,Converged" +
      " --mintime 0.005 --maxtime 900 #{options[i]}"

    lists.each do |list|
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

`./gen.results.rb`
