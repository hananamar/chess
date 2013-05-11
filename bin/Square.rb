class Square
  attr_accessor :row, :col, :piece, :game
  
  def initialize(col, row, game)
    @game = game
    @row = row
    @col = col
  end
  
  def to_s
    (@col+96).chr + @row.to_s
  end
  
  def to_a
    [col, row]
  end
  
  def ==(s)
    s.is_a?(Square) ? (row == s.row && col == s.col) : false
  end
  
  def color
    (@row + @col) % 2 == 0 ? :b : :w
  end
  
  def piece?
    !piece.nil?
  end
  
  def in_bounds?
    @row <= 8 && @row >= 1 && @col <= 8 && @col >= 1
  end
  
  def rel(arr)
    arr == [0,0] ? self : self.game.board[[self.col + arr[0], self.row + arr[1]]]
  end
  
  def adjacent
    adj = []
    for i in (-1..1) do
      for j in (-1..1) do
        unless i == 0 && j == 0
          s = game.board[[col+i,row+j]]
          adj << s unless s.nil?
        end
      end
    end
    adj
  end
  
  def knight_squares
    ks = []
    for i in [[2,1],[1,2],[-2,1],[-1,2],[2,-1],[1,-2],[-2,-1],[-1,-2]] do
      s = game.board[[@col+i[0], @row+i[1]]]
      ks << s unless s.nil?
    end
    ks
  end
  
  def diagonals
    diags = [[],[],[],[]]
    i = 1
    while row+i <=8 && col+i <= 8
      diags[0] << game.board[[col+i,row+i]]
      i += 1
    end
    i = 1
    while row-i >=1 && col+i <= 8
      diags[1] << game.board[[col+i,row-i]]
      i += 1
    end
    i = 1
    while row-i >=1 && col-i >= 1
      diags[2] << game.board[[col-i,row-i]]
      i += 1
    end
    i = 1
    while row+i <=8 && col-i >= 1
      diags[3] << game.board[[col-i,row+i]]
      i += 1
    end
    diags
  end
  
  def diagonals_unblocked(p_color = nil)
    directions = [[1,1], [1,-1], [-1,-1], [-1,1]]
    diags = [[],[],[],[]]
    
    for j in 0..3 do
      i = 1
      while true
        s = game.board[[col + i*directions[j][0], row + i*directions[j][1]]]
        break if s.nil?
        if s.occupied?
          unless p_color && s.piece.kind == :king && s.piece.other_color == p_color
            diags[j] << s
            break
          end
        end
        diags[j] << s
        i += 1
      end
    end

    diags
  end
  
  def straights
    str8s = [[],[],[],[]]
    i = 1
    while row+i <=8
      str8s[0] << game.board[[col,row+i]]
      i += 1
    end
    i = 1
    while col+i <=8 
      str8s[1] << game.board[[col+i,row]]
      i += 1
    end
    i = 1
    while row-i >=1
      str8s[2] << game.board[[col,row-i]]
      i += 1
    end
    i = 1
    while col-i >=1
      str8s[3] << game.board[[col-i,row]]
      i += 1
    end
    str8s
  end
  
  def straights_unblocked(p_color = nil)
    directions = [[0,1], [1,0], [0,-1], [-1,0]]
    str8s = [[],[],[],[]]
    for j in 0..3 do
      i = 1
      while true
        s = game.board[[col + i*directions[j][0], row + i*directions[j][1]]]
        break if s.nil?
        if s.occupied?
          unless p_color && s.piece.kind == :king && s.piece.other_color == p_color
            str8s[j] << s
            break
          end
        end
        str8s[j] << s
        i += 1
      end
      end
    str8s
  end
  
  def occupied?
    !piece.nil?
  end

  def occupied_by?(q_color)
    if piece.nil?
      false
    else
      piece.color == q_color ? true : false
    end
  end
  
  def attacked_by?(color)
    res = []
    @game.pieces[color].each do |p|
      if p.kind == :king
        if self.adjacent.include?(p.square)
          res << p.square
        end
      elsif p.attacked_squares.include?(self)
        res << p.square
      end
    end
    res = false if res.empty?
    res
  end
  
  def attackers # hash of white attackers array and black attackers array
    {w: [], b: []} # EDIT THIS
  end
  
  def remove_piece
    temp = @piece
    unless @piece.nil?
      game.pieces[@piece.color][game.pieces[@piece.color].index(@piece)] = nil
      @piece = nil
    end
    temp
  end
  
  def skewered_through_king?(color)
    k = @game.kings[color]
    attackers.each do |s|
      s.direction_to(self)
    end
  end
  
  def direction_to(s)
    # diag NW = [-1, 1]
    # row E = [1, 0]
    ans = [s.col <=> self.col, s.row <=> self.row]
  end
end