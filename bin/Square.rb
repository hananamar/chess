class Square
  attr_accessor :row, :col
  
  def initialize(col, row)
    @row = row
    @col = col
  end
  
  def to_s
    (@col+96).chr + @row.to_s
  end
  
  def ==(s)
    (row == s.row && col == s.col)
  end
  
  def color
    (@row + @col) % 2 == 0 ? :b : :w
  end
  
  def in_bounds?
    @row <= 8 && @row >= 1 && @col <= 8 && @col >= 1
  end
  
  def adjacent
    adj = []
    for i in (-1..1) do
      for j in (-1..1) do
        unless i == 0 && j == 0
          s = Square.new(@col+i, @row+j)
          adj << s if s.in_bounds?
        end
      end
    end
    adj
  end
  
  def knight_squares
    ks = []
    for i in [[2,1],[1,2],[-2,1],[-1,2],[2,-1],[1,-2],[-2,-1],[-1,-2]] do
      s = Square.new(@col+i[0], @row+i[1])
      ks << s if s.in_bounds?
    end
    ks
  end
  
  def diagonals
    diags = [[],[],[],[]]
    i = 1
    while row+i <=8 && col+i <= 8
      diags[0] << Square.new(col+i,row+i)
      i += 1
    end
    i = 1
    while row+i <=8 && col-i >= 1
      diags[1] << Square.new(col+i,row-i)
      i += 1
    end
    i = 1
    while row-i >=1 && col-i >= 1
      diags[2] << Square.new(col-i,row-i)
      i += 1
    end
    i = 1
    while row-i >=1 && col+i <= 8
      diags[3] << Square.new(col-i,row+i)
      i += 1
    end
    diags
  end
  
  def straights
    str8s = [[],[],[],[]]
    i = 1
    while row+i <=8
      str8s[0] << Square.new(col,row+i)
      i += 1
    end
    i = 1
    while col+i <=8 
      str8s[1] << Square.new(col+i,row)
      i += 1
    end
    i = 1
    while row-i >=1
      str8s[2] << Square.new(col,row-i)
      i += 1
    end
    i = 1
    while col-i >=1
      str8s[3] << Square.new(col-i,row)
      i += 1
    end
    str8s
  end
  
  def occupied?
    false # EDIT THIS
  end

  def occupied_by?(color)
    false # EDIT THIS
  end
  
  def attacked_by?(color) # should return number of attackers, false for no attackers
    false # EDIT THIS
  end
end