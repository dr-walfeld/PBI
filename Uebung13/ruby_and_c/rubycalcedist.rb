class RubyEditDistanceCalc

  def initialize(seq1, seq2)
    @seq1 = seq1
    @seq2 = seq2
    @dist = calculateDistance
  end

  def getEditDistance
    return @dist
  end

  def calculateDistance
    # take care to use {} to inintialise the internal arrays, if
    # Array.new(x, Array.new())
    # is used there will be ONE internal array that is referenced by all indices
    # of the outer Array
    d = Array.new(@seq1.length + 1) {Array.new(@seq2.length + 1)}

    0.upto(@seq1.length) do |i|
      d[i][0] = i
    end
    0.upto(@seq2.length) do |i|
      d[0][i] = i
    end

    1.upto(@seq1.length) do |idx_1|
      1.upto(@seq2.length) do |idx_2|
        equal = d[idx_1 - 1][idx_2 - 1]
        insertion = d[idx_1 - 1][idx_2] + 1
        deletion = d[idx_1][idx_2 - 1] + 1
        replacement = equal + 1
        if @seq1[idx_1 - 1] == @seq2[idx_2 - 1]
          d[idx_1][idx_2] = equal
        else
          d[idx_1][idx_2] = [insertion, deletion, replacement].min
        end
      end
    end

    return d[@seq1.length][@seq2.length]
  end
end
