#! /usr/bin/env ruby

class Matrix2D
  def initialize(m,n)
    if m < 1 or n < 1
      raise RuntimeError, "#{m} and #{n} are no valid matrix dimensions"
    end
    @data = Array.new(m) {Array.new(n)}
  end

  def set_value(i,j,value)
    check_range(i,j)
    @data[i-1][j-1] = value
  end
  
  def get_value(i,j)
    check_range(i,j)
    return @data[i-1][j-1]
  end

  def get_number_of_rows()
    return @data.length
  end

  def get_number_of_columns()
    return @data[0].length
  end

  def pretty_print
    @data.each do |row|
      puts row.join ";"
    end
  end
      

  private

  def check_range(i,j)
    if not i.between?(1,get_number_of_rows)
      raise ArgumentError, "index #{i} out of range!"
    end
    if not j.between?(1,get_number_of_columns)
      raise ArgumentError, "index #{j} out of range!"
    end
  end

end

if __FILE__ == $0
  begin
    matrix = Matrix2D.new(0,3)
  rescue => err
    puts err
  end

  m = 30
  n = 20

  begin
    matrix = Matrix2D.new(m,n)
    matrix.get_value(n,m)
  rescue => err
    puts err
  end

  m.times do |i|
    n.times do |j|
      matrix.set_value(i+1,j+1,(i+1)*(j+1))
    end
  end

  matrix.pretty_print

end
