#! /usr/bin/env ruby

def revertfile (content)
  content.reverse.each do |line|
    line.chomp!
    line.reverse!
    puts "#{line}"
  end
end

if ARGV.empty?
  filelist = ["testfile"]
else
  filelist = ARGV
end

filelist.each do |filename|
  puts "Reverse Ausgabe der Datei '#{filename}':"
  puts "---------------------------------------------------------------------"
  begin
    contentfile = File.open(filename, "r")
  rescue
    STDERR.puts "FEHLER: Datei #{filename} konnte nicht geoeffnet werden!"
    exit 1
  end
    content = contentfile.readlines
    revertfile(content)
    contentfile.close
  puts "---------------------------------------------------------------------"
  puts "---------------------------------------------------------------------"
end 
