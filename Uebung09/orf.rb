#! /usr/bin/env ruby

require 'pp'
require './fastaiterator.rb'

# search all overlapping ORFs in sequence (DNA)
def get_orfs(sequence)
  cnt = sequence.scan /(?=(ATG([ATGC]{3})*?(TGA|TA[AG])))/i
  return cnt.map {|entr| entr[0]}
end

# reverse complement of DNA sequence
def reverse_complement(sequence)
  cmpl = {'A' => 'T','T' => 'A','G' => 'C','C' => 'G', 'a' => 't', 't' => 'a', 'g' => 'c', 'c' => 'g'}
  output = ''
  sequence.each_char.reverse_each do |c|
    output += cmpl[c]
  end

  return output
end

# determine maximum-length ORF in sequence (and reverse complement)
def max_orf(sequence)
  orfs = get_orfs(sequence)
  orfs += get_orfs(reverse_complement(sequence))
  pp orfs
  maximum = orfs.max_by {|entr| entr.length}
end

# translate sequence into protein (with genetic code Hash)
def translate(sequence, gencode)
  protein = ''
  sequence.scan(/[ACGT]{3}/i).each do |codon|
    protein += gencode[codon.upcase]
  end
  return protein
end

if ARGV.length < 2
  puts "usage: #{$0} fasta-file geneticcode"
  exit 0
end

begin
  myFasta = FastaIterator.new(ARGV[0])
rescue => err
  puts "ERROR: #{err}"
  exit 1
end

begin
  file = File.open(ARGV[1])
  content = file.readlines
rescue
  puts "ERROR: could not open file #{ARGV[1]}"
  exit 1
end

gencode = {}
content.each do |line|
  if line.match /^\n/
    next
  end
  line.scan(/\s*([AGTC]{3})\s+([A-Z*])\s*/ ).each do |codon, aa|
    gencode[codon] = aa
  end
end

myFasta.each do |header,seq|
  maxorf = max_orf seq
  translated = translate(maxorf, gencode)
  puts header, maxorf, translated
end