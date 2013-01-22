# fasta iterator

class FastaIterator
  include Enumerable
  def initialize (fname)
    begin
      @filename = fname
      @sequences = parse_file 
    rescue
      raise RuntimeError, "could not open file #{fname}!"
    end
  end

  def length ()
    return @sequences.length
  end

  def each ()
    @sequences.each do |header, sequence|
      yield header, sequence
    end  
  end

  private

  def parse_file ()
    @sequences = []
    header = ""
    seq = ""

    file = File.open(@filename)
    file.each do |line|
      if line.match /^>/
        if not seq == ""
          if header == ""
            raise RuntimeError, "File is not FASTA, header missing!"
          end
          @sequences.push([header, seq.chomp])
          seq = ""
        end
        header = line.chomp
      # skip empty lines and comments
      elsif not line.match /^(\s+$|\s*#)/
        seq += line.gsub(/\s/,"")
      end
    end

    if header == ""
      raise RuntimeError, "File is not FASTA, header missing!"
    end

    if seq == ""
      raise RuntimeError, "File is not FASTA, sequence missing!"
    end

    @sequences.push([header, seq.chomp])
  end
end

        
