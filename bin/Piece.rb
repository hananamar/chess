class Piece
  path = 'C:/Sites/other/chess_game/bin/pieces'
  load "#{path}/king.rb"
  load "#{path}/queen.rb"
  load "#{path}/rook.rb"
  load "#{path}/bishop.rb"
  load "#{path}/knight.rb"
  load "#{path}/pawn.rb"
  attr_accessor :square, :kind, :color, :has_moved, :game, :king, :possible_moves, :attacked_squares, :attacking, :defending
  
  def initialize(game, square, color)
    @game = game
    @color = color
    @king = game.kings[color] unless @kind == :king
    @square = square
    @has_moved = false
  end
  
  def ==(s)
    s.is_a?(Piece) ? (kind == s.kind && square == s.square && color == s.color) : false
  end
  
  def other_color
    @color == :w ? :b : :w
  end
  
  def possible_moves
    # All legal moves, with check restrictions
    @possible_moves ||= self.can_move_to
  end
  
  def attacked_squares
    # All attacked squares, without check and pin restrictions
    @attacked_squares ||= self.can_attack
  end
  
  def attacking
    # Enemy pieces being attacked, contained in "possible moves"
    @attacking ||= attacked_squares.keep_if {|s| s.occupied_by?(other_color)}
  end
  
  def defending
    # Team pieces being defended, contained in "possible moves"
    @defending ||= attacked_squares.keep_if {|s| s.occupied_by?(@color)}
  end
end
