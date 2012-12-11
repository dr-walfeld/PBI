#! /usr/bin/env ruby

require './adjmol2.rb'

if __FILE__ == $0
  if ARGV.length < 2
    STDERR.puts "usage: #{$0} mol2-file bond-length"
    exit 0
  end
  begin
    bondlen = Integer(ARGV[1])
  rescue
    STDERR.puts "#{ARGV[1]} is no valid Integer!"
    exit 1
  end
  begin
    molcol = MoleculeCollection.new(ARGV[0])
  rescue => err
    STDERR.puts "ERROR: #{err}"
    exit 1
  end

  molcol.each do |molecule|
    # matrix is symmetric
    n = molecule.get_atom_number
    1.upto(n) do |i|
      i.upto(n) do |j|
        if molecule.get_distance(i,j) == bondlen
          puts "bind #{i} #{j}: #{molecule.get_atom(i)}:#{molecule.get_atom(j)}"
        end
      end
    end

    molecule.show_distancematrix
  end
end
