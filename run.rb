#!/usr/bin/env ruby
path = 'C:/Sites/other/chess_game'
require "#{path}/bin/Piece.rb"
require "#{path}/bin/Square.rb"
require "#{path}/bin/Game.rb"

def reload!
  path = 'C:/Sites/other/chess_game'
  load "#{path}/bin/Piece.rb"
  load "#{path}/bin/Square.rb"
  load "#{path}/bin/Game.rb"
end

def initialize_board
  for row in (1..8)
    for col in (1..8)
      eval %(@@#{(col+96).chr}#{row} = Square.new(col,row))
    end
  end
end

require 'irb'
IRB.start(__FILE__)