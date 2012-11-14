#! /usr/bin/env ruby

def sequences_from_fasta (data)
  seq = ''
  sequences = []
  data.each do |line|
    if line.match(/>/) and not seq == ''
      sequences.push (seq.gsub(/\s/,""))
      seq = ''
    elsif not line.match(/^(>|\s*$|\s*#)/)
      seq += line
    end
  end

  sequences.push (seq.gsub(/\s/,""))

  return sequences
end

def find_cds (sequence)
  lastp = 0
  in_cds = False
  start_stop = []
  # find start codons
  while ((start = sequence.index(/AUG/i,lastp)) != nil)
    if not in_cds
      start_stop.push (start)
      in_cds = True
    end
    while ((stop = sequence.index(/(UA[GA]|UGA)/i,lastp)) != nil \
           and stop%3 != start%3)
      lastp = stop+1
    end
    in_cds = False
    if not stop or (stop += 2) >= sequence.length
      stop = sequence.length-1
    end
    start_stop.push(stop)
  end

end

