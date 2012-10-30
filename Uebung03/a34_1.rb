#! /usr/bin/env ruby

def sumUp (m, n)
  result = 0
  if m <= n
    m.upto(n) do |i|
      result += i
    end
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

puts "Iterative Berechnung der Summe von m=#{m} bis n=#{n}: #{summe}"
