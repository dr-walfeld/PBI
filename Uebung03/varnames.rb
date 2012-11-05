#!/usr/bin/ruby
# This small example script is meant to be corrected. Some of the variable
# identifiers do not follow the rules of Ruby and/or do not follow the Ruby
# naming conventions.
# Additionally add comments to the identifiers to classify them as either
# *name
# *global
# *function
# *classname
# *instance variable
# *class variable

class humanbeing #*classname
  #counts the number of instances created
  HBCOUNTER = 0 #*class variable
  def initialize
    HBCOUNTER += 1
  end
  #getter function
  def Name #*function
    $1name + " " + 2name
  end
  #setter functions
  def firstname(name)
    $1name = name
  end
  def secondname(name)
    2name = name
  end
end

@Person = humanbeing.new

@Person.firstname("Peter")
@Person.secondname("Petersen")

puts @Person.Name
