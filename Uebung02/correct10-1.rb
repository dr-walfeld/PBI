#!/usr/bin/env ruby

dna = 'ACGAATT ACTTTAGC'
rna = dna.gsub(/T/, "U")

print "Here is the starting DNA: "
print "#{dna}\n"

print "Here is the result: "
puts "#{rna}\n"
exit 0
