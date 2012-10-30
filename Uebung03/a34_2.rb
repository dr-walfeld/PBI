#! /usr/bin/env ruby

def sumUp (m, n)
  result = 0
  if m > n
    result = 0
  elsif m == 0
    result = n*(n+1)/2
  else
    result = sumUp(0,n) - sumUp(0,m-1)
  end
  return result
end

if ARGV.length < 2
  puts "FEHLER: zu wenig Parameter angeben!"
  exit 1
end

m = ARGV[0].to_i
n = ARGV[1].to_i

summe = sumUp m, n

puts "Berechnung der Summe von m=#{m} bis n=#{n} mit Gauss: #{summe}"
