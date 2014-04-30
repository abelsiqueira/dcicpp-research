#!/usr/bin/env ruby

if ARGV.length == 0
  raise "ERROR: Need files"
end

success = ['Converged', 'Optimal']
use_success = false
data = {}
ARGV.each do |filename|
  if filename == "-s"
    use_success = true
    next
  elsif not File.exist?(filename)
    raise "ERROR: #{filename} does not exists"
  end
  data[filename] = {}
  open(filename) do |file|
    file.each_line do |line|
      sline = line.split
      if sline[0] == "#Name"
        next
      end
      data[filename][sline[0]] = sline[1,sline.length]
    end
  end
end

algs = data.keys
problems = data.values[0].keys

problems.each do |problem|
  fbest = 1e40
  failed = false
  algs.each do |alg|
    if use_success and not success.include?(data[alg][problem][0])
      failed = true;
      break
    end
    primal = data[alg][problem][3].to_f
    dual = data[alg][problem][4].to_f
    if [primal, dual].max < 1e-4
      fbest = [fbest, data[alg][problem][2].to_f].min
    else
      failed = true
      break
    end
  end
  if failed
    next
  end

  algs.each do |alg|
    fval = data[alg][problem][2].to_f
    if fval > fbest + 1e-3*fbest.abs + 1e-6
      failed = true
      break
    end
  end
  if failed
    next
  end
  output = [problem]
  algs.each { |alg|
    output << data[alg][problem][2].to_f
  }
  puts output.join(' ')
end
