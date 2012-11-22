#! /usr/bin/env ruby

require "./stack.rb"

def print_vienna(seq)
  brackets = Stack.new
  # the base pair
  printout = []
  # iterate over all characters
  seq.each_char.each_with_index do |c,i|
    # if open bracket => push to stack
    if c == "("
      brackets.push i+1
    # if close bracket => pop from stack and print pair
    # return false if stack empty (to many closing brackets)
    elsif c == ")"
      if brackets.empty?
        raise RuntimeError, "to many closing brackets"
      end
      printout.push [brackets.pop,i+1]
    # if there is an other char than . => invalid
    elsif c != "."
      raise RuntimeError, "#{c} is not an allowed symbol"
    end
  end
  # now the stack has to be empty => to many opening brackets otherwise
  if brackets.empty?
    printout.sort.each do |base1,base2|
      printf "%d-%d\n",base1,base2
    end
    return true
  else
    raise RuntimeError, "to many opening brackets"
  end

end


if ARGV.empty?
  printf "usage: %s filename\n",$0
  exit 1
end

begin
  infile = File.new(ARGV[0])
  lines = infile.readlines
  infile.close
rescue
  printf "ERROR: could not open file %s!\n", ARGV[0]
  exit 1
end

lines.each do |line|
  line.chomp!
  secondary, validity = line.split
  puts secondary
  begin
    valid = print_vienna(secondary)
  rescue => err
    puts "ERROR: #{err}"
    valid = false
  end
  printf "%s (",validity
  if valid
    printf "valid)\n"
  else
    printf "invalid)\n"
  end
end
