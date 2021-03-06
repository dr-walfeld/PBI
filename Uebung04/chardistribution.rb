#! /usr/bin/env ruby

def distribution (fileinput)
  dist = Array.new 256, 0
  newline = 0
  totalcount = 0
  begin
    fileinput.each do |line|
      newline += 1 # every line has exactly one newline
      line.each_char do |c|
        if c != "\n"
          dist[c.ord] += 1
          totalcount += 1
        end
      end
    end
  rescue
    puts "FEHLER: Datei kann nicht gelesen werden!"
    exit 1
  end

  return newline, totalcount, dist
end

def printDistribution newline, totalcount, dist
  puts "Anzahl Zeilen: #{newline}"
  puts "Gesamtzahl Zeichen (ohne newline): #{totalcount}"
  puts "Verteilung der einzelnen ASCII-Zeichen"
  printf "%8s %10s %10s\n", "ASCII", "absolut", "relativ"
  dist.each_index do |i|
    if dist[i] != 0
      printf "%8c", i.chr
      printf " %10d %10.2f\n", dist[i], dist[i].to_f/totalcount
    end
  end
end

if ARGF.nil?
  "FEHLER: keine Daten angegeben!"
  exit 1
end

newline, totalcount, dist = distribution ARGF
printDistribution(newline, totalcount, dist)
