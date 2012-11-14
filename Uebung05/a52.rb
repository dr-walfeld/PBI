#! /usr/bin/env ruby

def merge (a,b)
  out = []

  i = 0
  j = 0
  while i < a.length and j < b.length
    if a[i] < b[j]
      out.push(a[i])
      i += 1
    else
      out.push(b[j])
      j += 1
    end
  end
 
  if i == a.length
    max = j
    c = b
  else
    max = i
    c = a
  end



  max.upto(c.length-1) do |i|
    out.push(c[i])
  end
  return out
end
  

def mergesort(a)
  if a.length == 1
    return a
  end
 
  left = a[0..a.length/2-1]
  right = a[a.length/2..a.length-1]

  left = mergesort(left)
  right = mergesort(right)

  return merge(left,right)
end

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

begin
  a = read_int_array(content)
rescue => err
  puts "FEHLER: #{err}"
  exit 1
end

puts a.sort.inspect
b = mergesort(a)
puts b.inspect
