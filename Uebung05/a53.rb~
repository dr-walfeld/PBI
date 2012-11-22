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
  end

  if seq == ''
    raise RuntimeError, "FEHLER: Datei ist keine FASTA-Datei; Sequenz fehlt!"
  end

  sequences.push ([header, seq.gsub(/\s/,"")])

  return sequences
end

def find_cds (sequence)
  lastp = 0
  stop = -1
  start = -1
  outseq = ""
  # find start codons starting at the last stop-codon
  # => non-overlapping reading frames
  while ((start = sequence.index(/AUG/i,lastp)) != nil)
    # from last stop to start-1 no CDS
    if start != 0
      outseq += sequence[stop+1..start-1].downcase
    end

    lastp = start+3 # non-overlapping codons

    # look for the next stop codon that is in frame:
    # stop congruent start modulo 3
    while ((stop = sequence.index(/(UA[GA]|UGA)/i,lastp)) != nil \
           and stop%3 != start%3)
      lastp = stop+3 # stop-codons can't overlap anyway 
    end
    # if there is no stop => we have to stop at the sequence end
    if stop.nil?
      stop = sequence.length-1
    else
      stop = stop+2 # stop codon is part of the CDS
    end
    lastp = stop+1
    outseq += sequence[start..stop].upcase
  end

  # if we didn't stop at the last position
  if stop != sequence.length-1
    outseq += sequence[stop+1..-1].downcase
  end

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
  edit_sequence = find_cds (sequence)
  puts header
  puts edit_sequence
end
