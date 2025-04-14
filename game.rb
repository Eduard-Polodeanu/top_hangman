require "yaml"

class Game
  attr_accessor :code, :attempts_left, :used_letters, :current_progress

  def initialize
    @code = ""
    @used_letters = []
  end

  def start_game
    loop do
      puts "Do you want to start a new game or load a save file? [new/load]"
      input = gets.chomp.upcase
      return new_game if input == "NEW"
      return load_game if input == "LOAD"
    end
  end

  private

  def new_game
    puts "Starting new game..."
    create_code
    # puts code
    play
  end

  def load_game
    puts "Loading game from save file..."
    read_file = File.read("save_file.yml")
    from_yaml(read_file)
    # puts code
    play
  end

  def create_code
    loop do
      break unless code.length < 5 || code.length > 12

      @code = DICTIONARY[Random.rand(0...DICTIONARY.length)].upcase
      @attempts_left = [9, (5 + (code.length / 2.0)).floor].min
      @current_progress = Array.new(code.length) { "_" }
    end
  end

  def play
    loop do
      show_progress
      play_round
      if code == current_progress.join
        puts "\nYou won! The secret word was #{code}"
        break
      elsif attempts_left == 0
        puts "\nYou lost! No more attempts left."
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
      puts "Choose a letter from the english alphabet. Make sure you didn't use that letter already. \n[save] to save the current progress"
      input = gets.chomp.upcase
      save_game if input == "SAVE"
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

  def save_game
    File.write("save_file.yml", to_yaml)
    puts "\nGame saved!"
  end

  def to_yaml
    YAML.dump({
                code: @code,
                attempts_left: @attempts_left,
                used_letters: @used_letters,
                current_progress: @current_progress
              })
  end

  def from_yaml(yaml_string)
    data = YAML.load yaml_string
    @code = data[:code]
    @attempts_left = data[:attempts_left]
    @used_letters = data[:used_letters]
    @current_progress = data[:current_progress]
  end
end
