class Move
  attr_accessor :game, :from_square, :to_square, :num, :executed, :piece, :taken_piece

  def  initialize(game, from_square, to_square)
    @game = game
    @executed = false
    @from_square = from_square
    raise 'No Piece' if from_square.piece.nil?
    @to_square = to_square
    @num = game.turn_num
    @piece = from_square.piece
  end
  
  def to_s
    "#{num}. #{'...' if piece.color == :b}#{piece.init}#{to_square}"
  end
  
  def inspect
    to_s
  end
  
  def execute
    raise 'Already Executed' if @executed
    raise 'Invalid Move' unless is_possible?
    
    pawn_direction = @piece.color == :w ? 1 : -1 if @piece.kind == :pawn
    if to_square.piece
      @taken_piece = to_square.piece
      i = game.pieces[@taken_piece.color].index(@taken_piece)
      game.pieces[to_square.piece.color][i] = nil unless i.nil?
    elsif en_passent?
      @taken_piece = game.board[[to_square.col, to_square.row - pawn_direction]].piece
      game.pieces[@taken_piece.color].delete(@taken_piece)
    else
      game.board[to_square.to_a].piece = game.board[from_square.to_a].piece
      game.board[from_square.to_a].piece = nil
    end
    piece.square = to_square
    piece.possible_moves = nil
    game.moves << self
    game.to_move = piece.other_color
    game.en_passent = game.board[[to_square.col, to_square.row - pawn_direction]] if pawn_direction && (to_square.row - from_square.row == 2 || to_square.row - from_square.row == -2)
    @executed = true
  end
  
  def revert
    raise 'Not Executed' unless @executed
    raise 'Not Last Move' unless self == game.moves.last
    
    pawn_direction = @piece.color == :w ? 1 : -1 if @piece.kind == :pawn
    game.board[from_square.to_a].piece = game.board[to_square.to_a].piece
    piece.square = from_square
    if en_passent?
      game.board[[to_square.col, to_square.row + pawn_direction]].piece = @taken_piece
    else
      game.board[to_square.to_a].piece = @taken_piece
    end
    game.moves.pop
    game.to_move = piece.color
    @executed = false
    true
  end
  
  def is_possible?
    @game.to_move == @piece.color && @piece.possible_moves.include?(@to_square)
  end
  
  def en_passent?
    @piece.kind == :pawn && @to_square == game.en_passent
  end
end