#! /usr/bin/env ruby

require './fastaiterator.rb'

def length_distribution (fastait, binsize)
  len = 0
  dist = Hash.new(0)
  fastait.each do |header, sequence|
    len = sequence.length
    # 1-10 => bin0 11-20 => bin1 etc.
    dist[(len-1)/binsize] += 1
  end

  return dist
end


if ARGV.length < 3
  STDERR.puts "usage: #{$0} fastafile linewidth binsize"
  exit 1
end

begin
  n = Integer(ARGV[1])
rescue
  STDERR.puts "ERROR: #{ARGV[1]} is no valid Integer!"
  exit 1
end
begin
  binsize = Integer(ARGV[2])
rescue
  STDERR.puts "ERROR: #{ARGV[2]} is no valid Integer!"
  exit 1
end

begin
  # new fasta iterator
  my_fasta = FastaIterator.new ARGV[0]
  # print out header and formatted sequence
  my_fasta.each do |header, sequence|
    puts header
    sequence.scan(/.{1,#{n}}/).each do |match|
      puts match
    end
  end

  # new length distribution
  dist = length_distribution(my_fasta, binsize)

  dist.sort.each do |key, value|
    puts "#{key*binsize+1}..#{(key+1)*binsize}: #{value}"
  end

rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end
