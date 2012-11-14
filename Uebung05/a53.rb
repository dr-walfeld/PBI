#! /usr/bin/env ruby

def sequences_from_fasta (data)
  seq = ''
  header = ''
  sequences = []
  data.each do |line|
    if line.match(/>/) 
      if not seq == ''
        if header == ''
          raise RuntimeError, "FEHLER: Datei ist keine FASTA-Datei; Header fehlt!"
          return nil
        end
        sequences.push ([header, seq.gsub(/\s/,"")])
        seq = ''
      end
      header = line.gsub(/\n/,"")
    elsif not line.match(/^(>|\s*$|\s*#)/)
      seq += line
    end
  end

  if header == ''
    raise RuntimeError, "FEHLER: Datei ist keine FASTA-Datei; Header fehlt!"
    return nil
  end

  if seq == ''
    raise RuntimeError, "FEHLER: Datei ist keine FASTA-Datei; Sequenz fehlt!"
    return nil
  end

  sequences.push ([header, seq.gsub(/\s/,"")])

  return sequences
end

def find_cds (sequence)
  lastp = 0
  in_cds = false
  start_stop = []
  # find start codons
  while ((start = sequence.index(/AUG/i,lastp)) != nil)
    lastp = start+3 # non-overlapping codons
    #puts lastp
    # if not already in coding sequence => add start to list;
    # assumes that there are no overlapping reading frames
    if not in_cds
      start_stop.push (start)
      in_cds = true
    end
    # look for the next stop codon that is in frame:
    # stop congruent start modulo 3
    while ((stop = sequence.index(/(UAG|UAA|UGA)/i,lastp)) != nil \
           and stop%3 != start%3)
      lastp = stop+3 # add 3 so non-overlapping with next start
                     # no problem for next stop (stop codons
                     # can not overlap
    end
    lastp = stop+3
    # now we have found a stop codon or reached the end
    # of the sequence
    in_cds = false
    # if there is no stop => we have to stop at the sequence end
    if not stop 
      lastp = sequence.length-1
      stop = sequence.length-1
    end
    # add stop codon and repeat search from the start codon
    start_stop.push(stop)
  end

  return start_stop

end

def upper_lower_sequence(sequence,start_stop)
  outseq = ""
  if start_stop.empty?
    return sequence.downcase
  end
  outseq += sequence[0..start_stop[0]-1].downcase
  i = 0
  while i < start_stop.length-1
    if (i%2 == 0)
      outseq += sequence[start_stop[i]..start_stop[i+1]-1].upcase
    else
      outseq += sequence[start_stop[i]..start_stop[i+1]-1].downcase
    end
    i += 1
  end

  outseq += sequence[start_stop[start_stop.length-1]..sequence.length-1].downcase

  return outseq
end

if ARGV.empty?
  puts "FEHLER: Kein Dateiname angegeben!"
  exit 1;
end

begin
  file = File.new (ARGV[0])
  content = file.readlines
  file.close
rescue
  puts "FEHLER: Datei #{ARGV[0]} konnte nicht geoeffnet werden!"
  exit 1;
end

begin
  sequences = sequences_from_fasta(content)
rescue => err
  puts err
  exit 1
end

sequences.each do |header,sequence|
  start_stop = find_cds (sequence)
  edit_sequence = upper_lower_sequence(sequence,start_stop)
  puts header
  puts edit_sequence
end
