#! /usr/bin/env ruby

def merge(a,b)
  out = []
  while a.length > 0 or b.length > 0
    if a.length > 0 and b.length > 0
      if a[0] <= b[0]
        out.push(a[0])
        a = a[1..-1]
      else
        out.push(b[0])
        b = b[1..-1]
      end
    elsif a.length > 0
      out += a
      a.clear
    elsif b.length > 0
      out += b
      b.clear
    end
  end

  return out
end
  

def mergesort(a)
  if a.length <= 1
    return a
  end
 
  middle = a.length/2
  left = a[0..middle-1]
  right = a[middle..-1]

  left = mergesort(left)
  right = mergesort(right)

  return merge(left,right)
end

# extract all integer numbers from lines
def read_int_array(lines)
  out = []
  lines.each do |line|
    values = line.scan(/\d+/).flatten
    values.each do |value|
      out.push(value.to_i)
    end
  end
  return out
end

if ARGV.empty?
  puts "FEHLER: Es muss eine Datei zum Sortieren angegeben werden!"
  exit 1
end

begin
  file = File.new(ARGV[0])
  content = file.readlines
  file.close
rescue
  puts "FEHLER: Die Datei #{ARGV[0]} konnte nicht geoeffnet werden!"
  exit 1
end

a = read_int_array(content)

b = mergesort(a)
puts "Array sortiert mit Merge-Sort"
puts b.inspect
puts "Array sortiet durch Ruby-interne Funktion"
puts a.sort.inspect
