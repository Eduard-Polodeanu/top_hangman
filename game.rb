class Game
  attr_accessor :code, :attempts_left, :used_letters, :current_progress

  def initialize
    @code = ""
    @used_letters = []
  end

  def create_code
    loop do
      break unless code.length < 5 || code.length > 12

      @code = DICTIONARY[Random.rand(0...DICTIONARY.length)].upcase
      @attempts_left = code.length
      @current_progress = Array.new(code.length) { "_" }
    end
  end

  def play
    create_code
    puts code
    loop do
      show_progress
      play_round
      if attempts_left == 0
        puts "\nYou lost! No more attempts left."
        break
      elsif code == current_progress.join
        puts "\nYou won! The secret word was #{code}"
        break
      end
    end
  end

  def show_progress
    puts "\nAttempts left: #{attempts_left}, used letters: #{used_letters.join(' ')}\n\t#{current_progress.join(' ')}"
  end

  def play_round
    letter = ask_input
    check_match(letter)
  end

  def ask_input
    loop do
      puts "Choose a letter from the english alphabet. Make sure you didn't use that letter already."
      input = gets.chomp.upcase

      return input unless input.length != 1 || !ALLOWED_LETTERS.include?(input) || used_letters.join.include?(input)
    end
  end

  def check_match(letter)
    indexes_array = find_char_indexes(code, letter)
    if indexes_array.empty?
      puts "The letter #{letter} was not found in the secret word."
    else
      indexes_array.each do |index|
        current_progress[index] = letter
      end
    end
    @attempts_left -= 1
    @used_letters.push(letter)
  end

  def find_char_indexes(string, char, start = 0)
    idx = string[start, string.length].index(char)
    return [] unless idx

    [idx + start] + find_char_indexes(string, char, idx + start + 1)
  end
end
