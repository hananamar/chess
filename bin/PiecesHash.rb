class PiecesHash < Hash
  def gen(g = Game.new)
    g.pieces[g.to_move].each do |p|
      self["#{p.to_symbol}#{p.square}"] = {square: p.square, piece: p, moves: p.possible_moves.map{|s| Move.new(g, p.square, s)}}
    end
    self.delete_if {|k, v| v.empty? }
  end
  def pieces
    values.map{|v| v[:piece]}
  end
  def squares
    values.map{|v| v[:square]}
  end
  def moves
    values.map{|v| v[:moves]}
  end
  def squares_count
    squares.flatten.size
  end
  def moves_count
    moves.flatten.size
  end
end