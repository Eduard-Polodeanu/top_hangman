require_relative "game"

DICTIONARY = File.read("google-10000-english-no-swears.txt").split("\n")
ALLOWED_LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze

game = Game.new

game.play
