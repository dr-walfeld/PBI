#! /usr/bin/env ruby

def parse_mol2(filename)
  begin
    file = File.new(filename)
  rescue
    raise IOError, "could not open file #{filename}!"
  end

  file.each("@<TRIPOS>MOLECULE").each_with_index do |entr,i|
    puts i, "@<TRIPOS>MOLECULE",entr
  end

  file.close
end

parse_mol2(ARGV[0])
