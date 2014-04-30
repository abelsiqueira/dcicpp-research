#!/usr/bin/env ruby

def open_cutest(filename)
  cutest = {}
  open(filename).each_line do |line|
    sline = line.split
    if sline[0] == "#Name"
      next
    end
    cutest[sline[0]] = {
      "ef"=>sline[1],
      "time"=>sline[2],
      "fval"=>sline[3],
      "inf"=>[sline[4].to_f,sline[5].to_f].max
    }
  end
  cutest
end

data = {
  "algencan"=>open_cutest('cutest.algencan'),
  "dcicpp"=>open_cutest('cutest.dcicpp')
}

problems = data["algencan"].keys

inf_tol = 1e-4
ftol = 1e-3
f0 = 1e-6

algencan_wins = []
dcicpp_wins = []
algencan_wins_f = []
dcicpp_wins_f = []

problems.each do |problem|
  inf1 = data["algencan"][problem]["inf"]
  inf2 = data["dcicpp"][problem]["inf"]

  if inf1 < inf_tol and inf2 >= inf_tol
    algencan_wins << problem
  elsif inf1 >= inf_tol and inf2 < inf_tol
    dcicpp_wins << problem
  elsif inf1 >= inf_tol and inf2 >= inf_tol
    next
  else
    f1 = data["algencan"][problem]["fval"].to_f
    f2 = data["dcicpp"][problem]["fval"].to_f
    if f1 > f2 + ftol*f2.abs + f0
      dcicpp_wins_f << problem
    elsif f2 > f1 + ftol*f1.abs + f0
      algencan_wins_f << problem
    end
  end
end

puts algencan_wins.length
puts dcicpp_wins.length
puts algencan_wins_f.length
puts dcicpp_wins_f.length

