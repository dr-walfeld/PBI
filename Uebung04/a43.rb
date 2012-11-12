#! /usr/bin/env ruby

if ARGV.empty?
  n = 1000
else
  begin
    n = Integer(ARGV[0])
  rescue
    puts "FEHLER: #{ARGV[0]} ist keine ganze Zahl"
    exit 1
  end
end

erathostenes = Array.new n+1, true
erathostenes[0] = false
erathostenes[1] = false

2.upto(Math.sqrt(n)) do |i|
 if erathostenes[i]
  2.upto(n/i) do |j|
   erathostenes[i*j] = false
  end
 end
end

counter = 0
erathostenes.each_index.reverse_each do |i|
  if erathostenes[i]
    counter += 1
    if counter <= 5
      puts "#{counter}. groesste Primzahl <= #{n}: #{i}"
    end
  end
end

puts "Es gibt #{counter} Primzahlen <= #{n}"
