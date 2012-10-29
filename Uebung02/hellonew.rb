#! /usr/bin/env ruby

if ARGV.respond_to?("each")
  ARGV.each do |name|
    puts "Hallo #{name}"
  end
else
  puts "Hallo Welt"
end
