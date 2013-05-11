class Game
  attr_accessor :turn_num, :to_move, :pieces, :moves, :board, :kings, :check, :en_passent, :moves_50, :available_castlings
  
  def initialize(options = {})
    @board = Hash.new
    for row in (1..8)
      for col in (1..8)
        @board[[col, row]] = Square.new(col,row, self)
      end
    end
    
    @moves = []
    @pieces = {w: [], b: []}
    @kings = {w: nil, b: nil}
    @available_castlings = {q: true, k: true, Q: true, K: true}

    if options == {}
      @to_move = :w
      @turn_num = 1
      @check = false
      
      @kings[:w] = King.new(self, board[[5, 1]], :w)
      @pieces[:w] << board[[5, 1]].piece =  @kings[:w]
      @pieces[:w] << board[[4, 1]].piece =  Queen.new(self, board[[4, 1]], :w)
      @pieces[:w] << board[[3, 1]].piece = Bishop.new(self, board[[3, 1]], :w)
      @pieces[:w] << board[[6, 1]].piece = Bishop.new(self, board[[6, 1]], :w)
      @pieces[:w] << board[[7, 1]].piece = Knight.new(self, board[[7, 1]], :w)
      @pieces[:w] << board[[2, 1]].piece = Knight.new(self, board[[2, 1]], :w)
      @pieces[:w] << board[[1, 1]].piece =   Rook.new(self, board[[1, 1]], :w)
      @pieces[:w] << board[[8, 1]].piece =   Rook.new(self, board[[8, 1]], :w)
      
      for i in (1..8) do
        @pieces[:w] << board[[i, 2]].piece = Pawn.new(self, board[[i, 2]], :w)
      end
      
      @kings[:b] = King.new(self, board[[5, 8]], :b)
      @pieces[:b] << board[[5, 8]].piece =  @kings[:b]
      @pieces[:b] << board[[4, 8]].piece =  Queen.new(self, board[[4, 8]], :b)
      @pieces[:b] << board[[6, 8]].piece = Bishop.new(self, board[[6, 8]], :b)
      @pieces[:b] << board[[3, 8]].piece = Bishop.new(self, board[[3, 8]], :b)
      @pieces[:b] << board[[7, 8]].piece = Knight.new(self, board[[7, 8]], :b)
      @pieces[:b] << board[[2, 8]].piece = Knight.new(self, board[[2, 8]], :b)
      @pieces[:b] << board[[1, 8]].piece =   Rook.new(self, board[[1, 8]], :b)
      @pieces[:b] << board[[8, 8]].piece =   Rook.new(self, board[[8, 8]], :b)
      
      for i in (1..8) do
        @pieces[:b] << board[[i, 7]].piece = Pawn.new(self, board[[i, 7]], :b)
      end
    
    elsif !options[:fen].nil?
      row, col, set_board = 8, 1, true
      str = ''
      options[:fen].chars do |c|
        if set_board
          case c
            when '/'; row -= 1; col = 0
            when /[Qq]/
              @pieces[c == c.upcase ? :w : :b] << board[[col, row]].piece =  Queen.new(self, board[[col, row]], c == c.upcase ? :w : :b)
            when /[Rr]/
              @pieces[c == c.upcase ? :w : :b] << board[[col, row]].piece =  Rook.new(self, board[[col, row]], c == c.upcase ? :w : :b)
            when /[Bb]/
              @pieces[c == c.upcase ? :w : :b] << board[[col, row]].piece =  Bishop.new(self, board[[col, row]], c == c.upcase ? :w : :b)
            when /[Nn]/
              @pieces[c == c.upcase ? :w : :b] << board[[col, row]].piece =  Knight.new(self, board[[col, row]], c == c.upcase ? :w : :b)
            when /[Pp]/
              @pieces[c == c.upcase ? :w : :b] << board[[col, row]].piece =  Pawn.new(self, board[[col, row]], c == c.upcase ? :w : :b)
            when /[Kk]/
              @kings[c == c.upcase ? :w : :b] = King.new(self, board[[col, row]], c == c.upcase ? :w : :b)
              @pieces[c == c.upcase ? :w : :b] << board[[col, row]].piece =  @kings[c == c.upcase ? :w : :b]
            when /[1-8]/
              col += c.to_i - 1
          end
          col += 1
          if c == ' '
            set_board = false
          end
        else
          str << c
        end
      end
      options_from_fen = str.split(' ')
      unless options_from_fen[0].nil?
        @to_move = options_from_fen[0].to_sym 
      else
        @to_move = :w
      end
      
      self.find_checks
      
      unless options_from_fen[1].nil? && options_from_fen[1] != '-'
        for dir in %w[k K q Q]
          @available_castlings[dir.to_sym] = options_from_fen[1].include?(dir)
        end
      else
        @available_castlings = {k: false, K: false, q: false, Q: false}
      end
      unless options_from_fen[2].nil? || options_from_fen[2] == '-'
        @en_passent = board[options_from_fen[2].to_square]
      else
        @en_passent = nil
      end
      @moves_50 = options_from_fen[3] unless options_from_fen[3].nil?
      @turn_num = options_from_fen[4] unless options_from_fen[4].nil?
      
    else
      @to_move = options[:to_move]
      @turn_num = options[:turn_num]
      for piece in options[:pieces] do
        @pieces[piece.color] << piece
      end
    end
  end
  
  # def to_fen(fen)
    # row = 8
    # col = 1
    # str = fen
    # while str.length > 0 do
      # if str[0] =~ /1-8/
        # col += str[0].to_i
        # str = str[1..-1]
        # next
      # end
      # if str[0] == '/'
        # str = str[1..-1]
        # row -= 1
        # next
      # end
    # end
    # .
    # .
    # .
  # end
  
  def from_fen
    
  end
  
  def possible_moves
    PiecesHash.new.gen(self)
  end
  
  def find_best_move
    start = Time.now
    pm = possible_moves
    res = []
    pm.moves.flatten.each_with_index do |move, i|
      move.execute
      res[i] = [move, self.calculate_points]
      move.revert
    end
    i = res.each_with_index.max_by { |x, n| x[1][0] }[1]
    fin = Time.now
    p "#{res[i][0]} (#{fin-start})"
    nil
  end
  
  def calculate_points
    res = [0, 0]
    res = [10000, 0] if mate?
    res
  end
  
  def to_s
    str1 = %( - || - | - | - | - | - | - | - | - ||) + "\n"
    str2 = %(   ||===|===|===|===|===|===|===|===|)
    str = "\n" + str2 + "|\n"
    for row_ in 1..8 do
      row = 9-row_
      str << str1 unless row == 8
      row_str = " #{row} ||"
      for col in 1..8
        row_str << ' ' + (self.board[[col, row]].piece.nil? ? ' ' : (self.board[[col, row]].piece.to_symbol))  + ' |'
      end
      str << row_str << "|\n" 
    end
    str << str2 << "|\n" << %( #{@to_move.to_s.upcase} || a | b | c | d | e | f | g | h ||)
  end
  
  def mate?
    k = self.kings[@to_move]
    k.in_check? && self.possible_moves.moves.flatten == []
  end
  
  def last_move
    self.moves.last
  end
  def undo_move
    self.moves.last.revert
  end
  
  def state
    {c: @available_castlings, e: @en_passent, m50: @moves_50}
  end
  
  def find_checks
    checkers = self.kings[@to_move].in_check?
    if checkers
      checkers.each do |c|
        @check = Check.new(self, c, self.kings[@to_move].square)
      end
    else
      @check = false
    end
  end
end