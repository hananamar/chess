class Bishop < Piece
  def  initialize(game, square, color)
    @kind = :bishop
    super(game, square, color)
  end
  
  def to_s
    "#{@color == :w ? 'White' : 'Black'} bishop @ #{@square}"
  end
  
  def init
    "B"
  end
  
  def to_symbol
    @color == :w ? 'B' : 'b'
  end

  def can_move_to
    pm = @square.diagonals_unblocked.flatten.delete_if {|s| s.occupied? && s.occupied_by?(@color) }
    pm = [] if game.kings[@color].in_check?
    pm
  end
  
  def can_attack
    @square.diagonals_unblocked.flatten
  end
end