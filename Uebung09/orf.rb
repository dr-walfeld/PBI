#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__))

require 'pp'
# use fasta iterator from excecise 7
require 'fastaiterator.rb'

# search all overlapping ORFs in sequence (DNA)
def get_orfs(sequence)
  # search for ORFs overlapping, non-greedy and case-insensitive
  cnt = sequence.scan /(?=(ATG([ATGC]{3})*?(TGA|TA[AG])))/i
  # return first element in each scan-result (the rest are the other groups)
  return cnt.map {|entr| entr.first}
end

# reverse complement of DNA sequence
def reverse_complement(sequence)
  cmpl = {'A' => 'T','T' => 'A','G' => 'C','C' => 'G', \
          'a' => 't', 't' => 'a', 'g' => 'c', 'c' => 'g'}
  output = ''
  sequence.each_char.reverse_each do |c|
    if not cmpl.has_key? c
      raise RuntimeError, "#{c} is not an allowed character for 
      translatable DNA sequence!"
    end
    output += cmpl[c]
  end

  return output
end

# determine maximum-length ORF in sequence (and reverse complement)
def max_orf(sequence)
  # calculate reverse complement (and simulatanously check validity)
  revcomp = reverse_complement(sequence)
  # get all orfs of sequence
  orfs = get_orfs(sequence)
  # ... and its reverse complement
  orfs += get_orfs(revcomp)
  #pp orfs
  # determine orf of maximal length
  maximum = orfs.max_by {|entr| entr.length}

  return maximum
end

# translate sequence into protein (with genetic code Hash)
# translates complete sequence starting at 0 (no search for ORFs)
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

# read genetic code from file
# reads all matches of format "NNN A"
gencode = {}
content.each do |line|
  if line.match /^\n/
    next
  end
  line.scan(/\s*([AGTC]{3})\s+([A-Z*])\s*/ ).each do |codon, aa|
    gencode[codon] = aa
  end
end

# determine maximal ORF for each sequence in FASTA-file
begin
  myFasta.each do |header,seq|
    maxorf = max_orf seq
    translated = translate(maxorf, gencode)
    puts header, translated
  end
rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end
