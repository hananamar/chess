class King < Piece
  def  initialize(game, square, color)
    @kind = :king
    super(game, square, color)
  end
  
  def to_s
    "#{color == :w ? 'White' : 'Black'} king @ #{square}"
  end
  
  def init
    "K"
  end

  def to_symbol
    @color == :w ? 'K' : 'k'
  end

  def can_move_to
    pm = @square.adjacent.delete_if{|s| s.occupied_by?(@color) || s.attacked_by?(other_color)}
    pm << @game.board[[7, @square.row]] if @game.available_castlings[@color == :w ? :K : :k]
    pm << @game.board[[3, @square.row]] if @game.available_castlings[@color == :w ? :Q : :q]
    pm
  end
  
  def can_attack
    @square.adjacent
  end
  
  def can_move_to?(dest)
    @square.adjacent.include?(dest) && !dest.occupied_by?(@color) && !dest.attacked_by?(other_color)
  end
  
  def in_check?
    @square.attacked_by?(other_color)
  end
end