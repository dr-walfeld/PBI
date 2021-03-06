#! /usr/bin/env ruby

# calculate edit distances between all sequences in fasta-file
# with implementation in C and ruby;
# perform benchmark

require 'pp'
require 'benchmark'

# use FastaIterator for reading fasta-file
require './fastaiterator'
# implementation if edit distance calculation in C
require './calculateEditDistance'
# implementation if edit distance calculation in ruby
require './rubycalcedist'

if ARGV.empty?
  puts "usage: #{$0} fasta-file"
  exit 0
end

# read sequences
begin
  sequences = FastaIterator.new(ARGV[0])
rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end

# perform calculation of edit distances with ruby implementation and
# benchmark; calculation of each sequence vs. each sequence (redundant)
puts "Ruby-Implementation"
distancematrix_ruby = Array.new(sequences.length) {Array.new(sequences.length,-1)}

time_ruby = Benchmark.measure do
  sequences.each_with_index do |entr1, idx1|
    sequences.each_with_index do |entr2, idx2|
      redc = RubyEditDistanceCalc.new(entr1[1],entr2[1])
      distancematrix_ruby[idx1][idx2] = redc.getEditDistance
    end
  end
end

pp distancematrix_ruby
pp time_ruby

# perform calculation of edit distances with C implementation and
# benchmark; calculation of each sequence vs. each sequence (redundant)
puts "C-Implementation"
distancematrix_c = Array.new(sequences.length) {Array.new(sequences.length,-1)}

time_c = Benchmark.measure do
  sequences.each_with_index do |entr1, idx1|
    sequences.each_with_index do |entr2, idx2|
      edc = EditDistanceCalculator.new(entr1[1],entr2[1])
      distancematrix_c[idx1][idx2] = edc.getEditDistance
    end
  end
end

pp distancematrix_c
pp time_c

# compare results
distancematrix_ruby.zip(distancematrix_c).each do |rruby,rc|
  rruby.zip(rc).each do |vruby,vc|
    if vruby != vc
      STDERR.puts "ERROR: different results for C and ruby implementation!"
    end
  end
end
