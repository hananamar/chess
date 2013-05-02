class Pawn < Piece
  def  initialize(game, square, color)
    @kind = :pawn
    super(game, square, color)
  end
  
  def to_s
    "#{color == :w ? 'White' : 'Black'} pawn @ #{@square}"
  end

  def init
    ""
  end

  def to_symbol
    @color == :w ? 'P' : 'p'
  end
  
  def can_move_to
    if game.kings[color].in_check?
      [] 
      # need to fix to allow block & capture
    else
      possible = []
      direction = color == :w ? 1 : -1
      one_up = game.board[[@square.col, @square.row+direction]]
      unless one_up.occupied?
        possible << one_up
        two_up = game.board[[@square.col, @square.row+2*direction]]
        possible << two_up if @square.row == (color == :w ? 2 : 7) && !two_up.occupied?
      end
      diag1 = game.board[[@square.col+1, @square.row+direction]]
      possible << diag1 if diag1 && (diag1.occupied_by?(other_color) || diag1 == game.en_passent)
      diag2 = game.board[[@square.col-1, @square.row+direction]]
      possible << diag2 if diag2 && (diag2.occupied_by?(other_color) || diag2 == game.en_passent)
      possible
    end
  end
  
  def can_attack
    direction = color == :w ? 1 : -1
    [game.board[[@square.col+1, @square.row+direction]], game.board[[@square.col-1, @square.row+direction]]]
  end
  
  def attacking
    can_move_to.keep_if {|a| (a.occupied_by?(other_color) || a == game.en_passent) && a.col != @square.col}
  end
  
  def defending
    can_attack.keep_if {|a| a.occupied_by?(color)}
  end
end