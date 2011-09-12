$:.unshift(File.expand_path("../lib", __FILE__))
require "battleships/game"
require "battleships/console_renderer"

Dir[File.expand_path("../players/*.rb", __FILE__)].each do |path|
  load path
end

players = ARGV[0,2].map{ |s| Module.const_get(s).new }

game = Battleships::Game.new(10, [2, 3, 3, 4, 5], *players)
renderer = Battleships::ConsoleRenderer.new
renderer.render(game)

until game.winner
  game.tick
  renderer.render(game)
  sleep 1
end

puts "#{game.winner.name} won!"
