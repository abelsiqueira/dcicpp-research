#!/usr/bin/env ruby

dirs = `find . -name "comp*"`.split.sort

ftols = []
f0s = []
dirs.each do |dir|
  lists = `ls #{dir}/lists/samef_*.list`.split
  lists.each do |list|
    ftols << list[/f_([0-9]e[-+][0-9]*)/,1].to_f
    f0s << list[/[0-9]_([0-9]e[-+][0-9]*)/,1].to_f
  end
end
ftols = ftols.uniq.sort
f0s = f0s.uniq.sort

file = File.open("../resultados.tex",'w')

dirs.each do |dir|
  date = dir[/\.\/compare.(.*)/,1].gsub('.','_')
  f0s.each do |f0|
    ftols.each do |ftol|
      file.puts('\newpage')
      file.printf("\\subsection{Para $\\ftol = %1.0e$ e $f_0 = %1.0e$}\n", ftol, f0)
      file.puts('')
      file.puts('\begin{figure}[H]')
      file.puts('  \centering')
      samef = sprintf("samef_%1.0e_%1.0e", ftol, f0)

      lists = `ls #{dir}/lists/#{samef}_*.list`.split
      lists.each do |list|
        name = list[/#{dir}\/lists\/(.*).list/,1]
        str = ''
        str += '  \begin{subfigure}{0.48\textwidth}' + "\n"
        str += '    \includegraphics[width=\textwidth]'
        str += "{plots/#{name}_xf_#{date}.pdf}\n"
        str += '    \caption{' + name.gsub('_','-') + ' - '
        str += `wc -l #{list}`.split[0] + "}\n"
        str += '  \end{subfigure}' + "\n"
        file.puts(str)
      end

      file.puts('\end{figure}')
      file.puts('')
    end
  end
end

file.close
