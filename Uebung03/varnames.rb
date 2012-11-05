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

class HumanBeing #*classname
  #counts the number of instances created
  @@hbcounter = 0 #*class variable
  def initialize
    @@hbcounter += 1
  end
  #getter function
  def name #*function
    @first_name + " " + @second_name #*instance variable
  end
  #setter functions
  def first_name(name) #*method
    @first_name = name
  end
  def second_name(name)
    @second_name = name
  end
end

person = HumanBeing.new

person.first_name("Peter")
person.second_name("Petersen")

puts person.name
