class Game
  attr_accessor :turn, :white_pieces, :black_pieces
  
  def initialize(pieces = :default)
    @white_pieces = []
    @black_pieces = []
    
    if pieces == :default      
      @white_pieces <<   King.new(self, @@e1, :w)
      @white_pieces <<  Queen.new(self, @@d1, :w)
      @white_pieces << Bishop.new(self, @@c1, :w)
      @white_pieces << Bishop.new(self, @@f1, :w)
      @white_pieces << Knight.new(self, @@b1, :w)
      @white_pieces << Knight.new(self, @@g1, :w)
      @white_pieces <<   Rook.new(self, @@a1, :w)
      @white_pieces <<   Rook.new(self, @@h1, :w)
      
      for i in ('a'..'h') do
        @white_pieces << Pawn.new(self, eval("@@#{i}2"), :w)
      end
      
      @black_pieces <<   King.new(self, @@e8, :b)
      @black_pieces <<  Queen.new(self, @@d8, :b)
      @black_pieces << Bishop.new(self, @@c8, :b)
      @black_pieces << Bishop.new(self, @@f8, :b)
      @black_pieces << Knight.new(self, @@b8, :b)
      @black_pieces << Knight.new(self, @@g8, :b)
      @black_pieces <<   Rook.new(self, @@a8, :b)
      @black_pieces <<   Rook.new(self, @@h8, :b)
      
      for i in ('a'..'h') do
        @black_pieces << Pawn.new(self, eval("@@#{i}7"), :b)
      end
      
    else
      for piece in pieces do
        if piece.color == :w
          @white_pieces << piece
        else
          @black_pieces << piece
        end
      end
    end
  end
end