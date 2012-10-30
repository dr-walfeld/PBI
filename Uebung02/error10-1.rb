#!/usr/bin/env ruby

dna = 'ACGAATT\tACTTTAGC"'
rna = dna.gsub(/T/, "U")

print "Here is the starting DNA:\t"
print "#{dna}\n"

print "Here is the result:\t"
puts "#{rna}\n"
exit 0
