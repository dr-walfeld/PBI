require 'splitGB.rb'

class GenbankIterator

  # given filename, set fileobject
  def initialize (filename)
    @file = File.open(filename,"r")
    @records = []
    @file.each("//\n") do |rec|
      # ignore empty lines/records
      if not rec.match /^\s+$/m
        @records.push(rec)
      end
    end
  end

  def each
    @records.each do |rec|
      yield rec
    end
  end

  def each_ann_dna
    @records.each do |rec|
      an, dna = get_annotation_and_dna(rec)
      yield an, dna
    end
  end
end
