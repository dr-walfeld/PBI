#!/usr/bin/env ruby

dna = 'ACGAATT\tACTTTAGC'
rna = dna.gsub!(/T/, /U/)

print "Here "is the starting DNA:\t"
print "#{dna}\n\n"

print "Here is the result:\n\n"
puts "#{rna)\n"
exit 0
