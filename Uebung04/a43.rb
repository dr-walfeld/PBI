#! /usr/bin/env ruby

n = 1000
erathostenes = Array.new n+1, true
erathostenes[0] = false
erathostenes[1] = false

2.upto(sqrt(n)) do |i|
 if erathostenes[i]
  2.upto(n/i) do |j|
   erathostenes[i*j] = false
  end
 end
end


