#! /usr/bin/env ruby

# parsing file
# it is important that every fiels A-D is in each line in correct format;
# the order is not important and any other additional text is ignored
def parse(content)
  sum_hash = Hash.new(0)

  # allowed fiels
  fields = ['A','B','C','D']

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

    fields.each do |field|
      # only first occurence of a field in a line is used
      valueexp = line.scan(/(#{field}=\d+)/).flatten[0]
      
      # if one field is missing => incorrect file format
      if not valueexp
        raise RuntimeError, "Feld #{field} konnte nicht gefunden werden!"
      end
      
      # extract Integer value from field
      value = Integer(valueexp.scan(/\d+/).flatten[0])

      if not value
        raise RuntimeError, "Feld #{field} hat falsches Format!"
      end

      # determine if value or key
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
