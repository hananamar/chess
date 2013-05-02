class Rook < Piece
  def  initialize(game, square, color)
    @kind = :rook
    super(game, square, color)
  end
  
  def to_s
    "#{color == :w ? 'White' : 'Black'} rook @ #{square}"
  end

  def init
    "R"
  end
  
  def to_symbol
    @color == :w ? 'R' : 'r'
  end
  
  def can_move_to
    pm = @square.straights_unblocked.flatten
    pm.keep_if {|s| s == @game.check.from_square || @game.check.path.include?(s)} if game.kings[color].in_check?
    pm
  end
  
  def can_attack
    @square.straights_unblocked.flatten
  end
end