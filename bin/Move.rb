class Move
  attr_accessor :game, :from_square, :to_square, :executed, :piece, :taken_piece, :en_passent

  def initialize(game, from_square, to_square)
    @game = game
    @executed = false
    @from_square = from_square.is_a?(Square) ? from_square : @game.board[from_square.to_square]
    raise 'No Piece' if @from_square.piece.nil?
    @to_square = to_square.is_a?(Square) ? to_square : @game.board[to_square.to_square]
    @piece = @from_square.piece
  end
  
  def to_s
    "#{game.turn_num}. #{'...' if piece.color == :b}#{piece.init}#{to_square}"
  end
  
  def inspect
    to_s
  end
  
  def execute
    raise 'Already Executed' if @executed
    raise 'Invalid Move' unless is_possible?
    
    pawn_direction = @piece.color == :w ? 1 : -1 if @piece.kind == :pawn
    if @to_square.piece
      @taken_piece = @to_square.piece
      @game.pieces[@taken_piece.color].delete(@taken_piece)
    elsif en_passent?
      @en_passent = true
      @taken_piece = @game.board[[@to_square.col, @to_square.row - pawn_direction]].piece
      @game.pieces[@taken_piece.color].delete(@taken_piece)
    end
    @game.board[@to_square.to_a].piece = @game.board[@from_square.to_a].piece
    @game.board[@from_square.to_a].piece = nil
    @piece.square = @to_square
    @piece.possible_moves = nil
    
    @game.moves << self
    @game.to_move = @piece.other_color
    @game.en_passent = (pawn_direction && (@to_square.row - @from_square.row == 2 || @to_square.row - @from_square.row == -2)) ? @game.board[[@to_square.col, @to_square.row - pawn_direction]] : nil
    @state = @game.state
    @game.find_checks
    @executed = true
  end
  
  def revert
    raise 'Not Executed' unless @executed
    raise 'Not Last Move' unless self == game.last_move
    
    pawn_direction = @piece.color == :w ? 1 : -1 if @piece.kind == :pawn
    @game.board[@from_square.to_a].piece = @game.board[@to_square.to_a].piece
    @piece.square = @from_square
    if @en_passent
      @game.board[[@to_square.col, @to_square.row + pawn_direction]].piece = @taken_piece
    else
      @game.board[@to_square.to_a].piece = @taken_piece
    end
    @game.pieces[@taken_piece.color] << @taken_piece if @taken_piece
    @game.moves.pop
    @game.to_move = @piece.color
    @game.en_passent, @game.available_castlings, @game.moves_50 = @state[:e], @state[:c], @state[:m50]
    @game.find_checks
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