#! /usr/bin/env ruby

require './matrix2d.rb'

# extend Matrix2D pretty_print
class Matrix2D
  def pretty_print(atomlist)
    puts ";#{atomlist.join ";"}"
    @data.each_with_index do |row,i|
      puts"#{atomlist[i]};#{row.join ";"}"
    end
  end
end

class Molecule
  def initialize(name, numatoms, numbonds)
    @name = name
    @numatoms = numatoms
    @numbonds = numbonds
    @bondmatrix = Matrix2D.new(numatoms,numatoms)
    @atoms = []
  end

  def add_atom(num, name)
    if not num.between?(1,@numatoms)
      raise RuntimeError, "trying to add more atoms than initially specified!"
    end
    @atoms[num-1] = name
  end

  def add_bond(num, atomid1, atomid2)
    if not num.between?(1,@numbonds)
      raise RuntimeError, "trying to add more bonds than initially specified!"
    end

    begin
      @bondmatrix.set_value(atomid1, atomid2, 1)
      @bondmatrix.set_value(atomid2, atomid1, 1)
    rescue
      raise RuntimeError, "trying to add bond for non existing atom!"
    end
  end

  def print_molecule
    puts @name
    @bondmatrix.pretty_print(@atoms)
  end

end

class MoleculeCollection
  include Enumerable

  def initialize (filename)
    # read all entries except first
    begin
      file = File.new(filename)
    rescue
      raise IOError, "could not open file #{filename}!"
    end

    @molecules = []

    # skip first entry (commentary or nothing)
    file.readline("@<TRIPOS>MOLECULE\n")

    file.each("@<TRIPOS>MOLECULE\n").each do |entr|
      entr = entr.split /\n/
      molname = entr[0].chomp
      
      match = entr[1].match /^\s+(\d+)\s+(\d+)/
      if not match
        raise RuntimeError, "missing num line"
      end

      numatoms = match[1].to_i
      numbonds = match[2].to_i

      mol = Molecule.new(molname,numatoms,numbonds)
      
      inatoms = false
      inbonds = false

      entr.each do |line|
        if line.match /^@<TRIPOS>ATOM/
          inatoms = true
          inbonds = false
        elsif line.match /^@<TRIPOS>BOND/
          inbonds = true
          inatoms = false
        # if any other specifier is starting
        elsif line.match /^@/
          inbonds = false
          inatoms = false
        elsif inatoms
          if (match = line.match /^\s+(\d+)\s+(\w+)/)
            atomnum = match[1].to_i
            atomname = match[2]
            mol.add_atom(atomnum,atomname)
          elsif not line == "" and not line.match /^#/
            raise RuntimeError, "invalid atom specifier line '#{line.chomp}'"
          end
        elsif inbonds
          if (match = line.match /^\s+(\d+)\s+(\d+)\s+(\d+)/)
            bondnum = match[1].to_i
            atomid1 = match[2].to_i
            atomid2 = match[3].to_i
            mol.add_bond(bondnum, atomid1, atomid2)
          elsif not line == "" and not line.match /^#/
            raise RuntimeError, "invalid bond specifier line '#{line.chomp}'"
          end
        end
      end

      @molecules.push(mol)
    end
  end

  def each
    @molecules.each do |mol|
      yield mol
    end
  end

end

molcol = MoleculeCollection.new(ARGV[0])
molcol.each {|mol| mol.print_molecule}
