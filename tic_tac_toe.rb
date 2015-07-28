class Game
  attr_accessor :current_player, :board
  attr_reader :x_or_o

  def initialize
    @board = Board.new
    @ai = AI.new
    player = ["X", "O"].sample
    player == "X" ? @current_player = "human" : @current_player = "computer"
    other_player = human? ? "computer" : "human"
    @x_or_o = {@current_player => "X", other_player => "O"}
    before_game
  end

  def before_game
    puts "-----------------------"
    puts "Tic-tac-toe"
    puts "-----------------------"
    puts human? ? "You are going first!" : "You are going second!"
  end

  def start_game
    until is_game_over?
      next_turn
    end
  end

  def next_turn
    display_player_turn
    @board.draw_board
    move = human? ? get_player_choice : @ai.minimax
    @board.update_board(move, x_or_o[@current_player])
    switch_player
  end

  def display_player_turn
    puts human? ? "Your turn" : "Computer's turn"
  end

  def get_player_choice
    puts "Choose where to place an #{x_or_o[@current_player]} (1 - 9):"
    choice = gets.chomp.to_i
    choice = get_player_choice unless choice.between?(1, 9)
    puts choice
    return choice
  end

  def switch_player
    @current_player = human? ? "computer" : "human"
  end

  def human?
    @current_player == "human"
  end

  def is_game_over?
    false
  end

  def game_over
    puts "-----------------------"
    puts "Game Over"
    puts "-----------------------"
    puts "Press Enter to start a new game"
  end
end

class Board
  attr_accessor :moves

  def initialize
    @moves = Hash.new("-")
  end

  def draw_board
    (1..9).each_slice(3) do |x, y, z|
      puts "\t #{moves[x]} | #{moves[y]} | #{moves[z]} "
      puts "\t---+---+---" if x < 7
    end
  end

  def update_board(move, x_or_o)
    @moves[move] = x_or_o
  end
end

class AI
  def minimax
  end
end

game = Game.new
game.start_game
