#!/usr/bin/env ruby

if ARGV.length == 0
  raise "ERROR: Need files"
end

ftol = 5e-3
f0 = 1e-5

success = ['Converged', 'Optimal']
next_is_ftol = false
next_is_f0 = false

data = {}
ARGV.each do |arg|
  if next_is_ftol
    ftol = arg.to_f
    next_is_ftol = false
  elsif next_is_f0
    f0 = arg.to_f
    next_is_f0 = false
  elsif arg == "--ftol"
    next_is_ftol = true
  elsif arg == "--f0"
    next_is_f0 = true
  elsif not File.exist?(arg)
    raise "ERROR: #{arg} does not exists"
  else
    data[arg] = {}
    open(arg) do |file|
      file.each_line do |line|
        sline = line.split
        if sline[0] == "#Name"
          next
        end
        data[arg][sline[0]] = {
          "ef" => sline[1],
          "cost" => sline[2],
          "fval" => sline[3].to_f,
          "inf" => [sline[4].to_f, sline[5].to_f].max
        }
      end
    end
  end
end

algs = data.keys
problems = data.values[0].keys

# Only the problem where the converging algorithm (according to the exit flag)
# have the same function value (f < fbest + ftol*|fbest| + f0).
chosen = []

problems.each do |problem|
  fbest = 1e40
  algs.each do |alg|
    if success.include?(data[alg][problem]["ef"])
      fbest = [fbest, data[alg][problem]["fval"].to_f].min
    end
  end

  is_chosen = true
  algs.each do |alg|
    if success.include?(data[alg][problem]["ef"])
      f = data[alg][problem]["fval"].to_f
      if f >= fbest + ftol*fbest.abs + f0
        is_chosen = false
        break
      end
    end
  end
  if is_chosen
    chosen << problem
  end
end

puts chosen
