#! /usr/bin/env ruby

# rekursive Berechnung der Fakultaet
def faculty (n)
  if n == 0
    return 1
  else
    return n*faculty(n-1)
  end
end

# wenn kein Parameter uebergeben => Berechnung von 5!
if ARGV.empty?
  n = 5
else
  n = ARGV[0].to_i
end

fac = faculty(n)

puts "#{n}! = #{fac}"
