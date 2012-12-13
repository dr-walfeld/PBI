#! /usr/bin/env ruby

# show all atoms with distance of user-specified length

$:.unshift File.join(File.dirname(__FILE__))

# use representation of molecules as adjacency matrix
# from exercise 8 extended by distance calculation
require 'adjmol2.rb'

# check argument count
if ARGV.length < 2
  STDERR.puts "usage: #{$0} mol2-file bond-length"
  exit 0
end

# read bond length from command line
begin
  bondlen = Integer(ARGV[1])
rescue
  STDERR.puts "#{ARGV[1]} is no valid Integer!"
  exit 1
end

# read molecule collection from user-specified .mol2 file
begin
  molcol = MoleculeCollection.new(ARGV[0])
rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end

# look at all molecules in collection
molcol.each do |molecule|
  # matrix is symmetric
  n = molecule.get_atom_number
  1.upto(n) do |i|
    i.upto(n) do |j|
      # check if current atoms have questioned distance
      if molecule.get_distance(i,j) == bondlen
        puts "bind #{i} #{j}: #{molecule.get_atom(i)}:#{molecule.get_atom(j)}"
      end
    end
  end
  # show distance matrix
  molecule.show_distancematrix
end
