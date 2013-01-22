#! /usr/bin/env ruby

require 'pp'
require 'benchmark'

require './fastaiterator'
require './calculateEditDistance'
require './rubycalcedist'

if ARGV.empty?
  puts "usage: #{$0} fasta-file"
  exit 0
end

begin
  sequences = FastaIterator.new(ARGV[0])
rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end

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
