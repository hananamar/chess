#!/usr/bin/env ruby
path = '.'
require "#{path}/bin/Piece.rb"
require "#{path}/bin/Square.rb"
require "#{path}/bin/Game.rb"
require "#{path}/bin/Move.rb"
require "#{path}/bin/Check.rb"
require "#{path}/bin/PiecesHash.rb"

def reload!
  path = '.'
  load "#{path}/bin/Piece.rb"
  load "#{path}/bin/Square.rb"
  load "#{path}/bin/Game.rb"
  load "#{path}/bin/Move.rb"
  load "#{path}/bin/Check.rb"
  load "#{path}/bin/PiecesHash.rb"
end

def initialize_board(game)
  for row in (1..8)
    for col in (1..8)
      eval %(@@#{(col+96).chr}#{row} = game.board[[col,row]])
    end
  end
end

class String
  def to_square
    raise 'Invalid Square (must contain a letter and number only)' unless self.length == 2
    raise 'Invalid Square (first char must be a-h)' unless self[0] =~ /[a-h]/
    raise 'Invalid Square (second char must be 1-8)' unless self[1] =~ /[1-8]/
    [self[0].ord - 96, self[1].to_i]
  end
end

require 'pry'
pry
#IRB.start(__FILE__)