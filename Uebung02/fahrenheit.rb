#! /usr/bin/env ruby

# iteriert ueber alle natuerlichen Zahlen von 1 bis (einschließlich) 100
# und berechnet die jeweilige Temperatur in Fahrenheit
1.upto(100).each do |c|
  f = (c.to_f*9.0)/5.0+32.0
  printf("c = %.2f f = %.2f\n", c, f)
end
