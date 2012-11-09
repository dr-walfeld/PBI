#! /usr/bin/env ruby

def quersumme1 (i)
  summe = 0
  while i != 0
    summe += i%10
    i /= 10
  end
  return summe
end

def quersumme2 (s)
  summe = 0
  s.each_char do |c|
    summe += Integer(c)
  end
  return summe
end

if ARGV.empty?
  STDERR.puts "FEHLER: keine Parameter angegeben!"
  exit 1
end

begin
  i = Integer(ARGV[0])
rescue
  STDERR.puts "FEHLER: es wurde keine Zahl angegeben!"
  exit 1
end

puts "Quersumme von #{i}: #{quersumme1(i)}"
puts "Quersumme von #{i}: #{quersumme2(ARGV[0])}"
