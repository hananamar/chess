class Queen < Piece
  def  initialize(game, square, color)
    @kind = :queen
    super(game, square, color)
  end
  
  def to_s
    "#{color == :w ? 'White' : 'Black'} queen @ #{square}"
  end

  def init
    "Q"
  end

  def to_symbol
    @color == :w ? 'Q' : 'q'
  end

  def can_move_to
    pm = [@square.straights_unblocked.flatten, @square.diagonals_unblocked.flatten].flatten
    pm.delete_if {|s| s.occupied_by?(@color)}
    pm.keep_if {|s| s == @game.check.from_square || @game.check.path.include?(s)} if @game.kings[color].in_check?
    pm
  end
  
  def can_attack
    [@square.straights_unblocked(@color).flatten, @square.diagonals_unblocked(@color).flatten].flatten
  end
end