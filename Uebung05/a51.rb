#! /usr/bin/env ruby

# parsing file
def parse(content)
  sum_hash = Hash.new(0)

  content.each do |line|
    key = 0
    sum = 0
    if line.match(/^(\s*)$/) # empty lines are always ok
      next
    end

    # fields may be seperated by space or tab
    if not line.match(/^([ \t]*A=\d+[ \t]+B=\d+[ \t]+C=\d+[ \t]+D=\d+[ \t]*)$/)
      raise RuntimeError, "Zeile '#{line.gsub(/\n/,"")}' hat fehlerhaftes Format!"
    end
    # because the line format is verified => just extract the four ints
    values = line.scan(/\d+/).flatten
    key = values[0].to_i

    values[1..-1].each do |val|
      sum_hash[key] += val.to_i
    end

  end

  return sum_hash
end

if ARGV.empty?
  puts "FEHLER: keine Datei angegeben!"
  exit 1
end

begin
  file = File.new(ARGV[0], 'r')
  content = file.readlines
  file.close
rescue
  puts "FEHLER: Date #{ARGV[0]} konnte nicht geoeffnet werden!"
  exit 1
end

begin
  sum_hash = parse (content)
rescue => err
  puts "FEHLER: #{err}"
  exit 1
end

sum_hash.each_pair do |key, value|
  puts "sum[#{key}] = #{value}"
end
