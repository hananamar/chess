class Piece
  attr_accessor :square, :kind, :color, :has_moved, :game
  
  def other_color
    @color == :w ? :b : :w
  end
end

class King < Piece
  def  initialize(game, square, color = :w)
    @game = game
    @kind = :king
    @square = square
    @color = color
    @has_moved = false
  end
  
  def to_s
    "#{color == :w ? 'white' : 'black'} king @ #{square}"
  end
  
  def can_move_to
    possible = @square.adjacent
    possible.delete_if{|s| s.occupied_by?(@color) || s.attacked_by?(other_color)}
    possible
  end
  
  def can_move_to?(dest)
    @square.adjacent.include?(dest) && !dest.occupied_by?(@color) && !dest.attacked_by?(other_color)
  end
  
  def in_check?
    square.attacked_by?(other_color)
  end
  
  def attacking
    @square.adjacent
  end
end

class Pawn < Piece
  def  initialize(game, square, color = :w)
    @game = game
    @kind = :pawn
    @square = square
    @color = color
    @has_moved = false
  end
  
  def to_s
    "#{color == :w ? 'white' : 'black'} pawn @ #{square}"
  end
  
  def can_move_to # need to restrict when in check
    possible = []
    direction = color == :w ? 1 : -1
    one_up = Square.new(square.col, square.row+direction)
    unless one_up.occupied?
      possible << [one_up]
      two_up = Square.new(square.col, square.row+2*direction)
      possible << two_up unless two_up.occupied? || has_moved
    end
    diag1 = Square.new(square.col+1, square.row+direction)
    possible << diag1 if diag1.occupied_by?(other_color) # || diag1.en_passent
    diag2 = Square.new(square.col-1, square.row+direction)
    possible << diag2 if diag2.occupied_by?(other_color) # || diag2.en_passent
    possible
  end
  
  def attacking
    direction = color == :w ? 1 : -1
    attacking = []
    attacking << Square.new(square.col+1, square.row+direction) if square.col+1 <= 8 
    attacking << Square.new(square.col-1, square.row+direction) if square.col-1 >= 1
    attacking
  end
end

class Knight < Piece
  def  initialize(game, square, color = :w)
    @game = game
    @kind = :knight
    @square = square
    @color = color
    @has_moved = false
  end
  
  def to_s
    "#{color == :w ? 'white' : 'black'} knight @ #{square}"
  end
end

class Bishop < Piece
  def  initialize(game, square, color = :w)
    @game = game
    @kind = :bishop
    @square = square
    @color = color
    @has_moved = false
  end
  
  def to_s
    "#{color == :w ? 'white' : 'black'} bishop @ #{square}"
  end
end

class Rook < Piece
  def  initialize(game, square, color = :w)
    @game = game
    @kind = :rook
    @square = square
    @color = color
    @has_moved = false
  end
  
  def to_s
    "#{color == :w ? 'white' : 'black'} rook @ #{square}"
  end
end

class Queen < Piece
  def  initialize(game, square, color = :w)
    @game = game
    @kind = :queen
    @square = square
    @color = color
    @has_moved = false
  end
  
  def to_s
    "#{color == :w ? 'white' : 'black'} queen @ #{square}"
  end
end