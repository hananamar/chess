class Check
  attr_accessor :game, :from_square, :path, :double, :to_square, :num, :piece

  def  initialize(game, from_square, to_square)
    @game = game
    #@executed = false
    @from_square = from_square
    raise 'No piece' if from_square.piece.nil?
    raise 'King can`t check' if from_square.piece.kind == :king
    @to_square = to_square
    @num = game.turn_num
    @piece = from_square.piece
    if [:queen, :bishop, :rook].include?(@piece.kind)
      @path = calc_path
    else
      @path = []
    end
    @game.check = true
  end
  
  def calc_path
    direction = [0,0]
    if @from_square.row != @to_square.row
      direction[1] = @from_square.row < @to_square.row ? 1 : -1
    end
    if @from_square.col != @to_square.col
      direction[0] = @from_square.col < @to_square.col ? 1 : -1
    end
    
    path = []
    next_s = @from_square.rel(direction)
    while next_s != @to_square
      path << next_s
      next_s = next_s.rel(direction)
      raise 'Invalid Check' if next_s.nil?
    end
    path
  end
  
  def to_s
    "#{@piece.kind.to_s.capitalize} on #{@from_square} checking #{@piece.other_color == :w ? 'white' : 'black'} king"
  end
end