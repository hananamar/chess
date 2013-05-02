class Knight < Piece
  def  initialize(game, square, color)
    @kind = :knight
    super(game, square, color)
  end
  
  def to_s
    "#{color == :w ? 'White' : 'Black'} knight @ #{square}"
  end
  
  def init
    "N"
  end
  
  def to_symbol
    @color == :w ? 'N' : 'n'
  end
  
  def can_move_to
    pm = @square.knight_squares.delete_if {|s| s.occupied_by?(@color)}
    pm.keep_if {|s| s == @game.check.from_square || @game.check.path.include?(s)} if @game.check && !@game.check.double
    pm
  end
  
  def can_attack
    self.square.knight_squares
  end
end