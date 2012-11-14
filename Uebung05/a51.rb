#! /usr/bin/env ruby

def parse(file)
  content = file.readlines
  sum_hash = Hash.new(0)

  fields = ['A','B','C','D']

  content.each do |line|
    key = 0
    sum = 0

    fields.each do |field|
      valueexp = line.scan(/(#{field}=\d+)/).flatten[0]
      
      if not valueexp
        raise ArgumentError "Feld #{field} konnte nicht gefunden werden!"
      end
      
      value = Integer(valueexp.scan(/\d+/)[0])

      if not value
        raise ArgumentError "Feld #{field} hat falsches Format!"
      end

      if field == 'A'
        key = value
      else
        sum += value
      end
    end
    sum_hash[key] += sum
  end

  return sum_hash
end

if ARGV.empty?
  puts "FEHLER: keine Datei angegeben!"
  exit 1
end

begin
  file = File.new(ARGV[0], 'r')
rescue
  puts "FEHLER: Date #{ARGV[0]} konnte nicht geoeffnet werden!"
  exit 1
end

begin
  sum_hash = parse (file)
rescue => err
  puts "FEHLER: #{err}"
  file.close
  exit 1
end

sum_hash.each_pair do |key, value|
  puts "sum[#{key}] = #{value}"
end

file.close
