class Game
  attr_accessor :current_player, :board
  attr_reader :x_or_o

  def initialize
    @board = Board.new
    player = ["X", "O"].sample
    player == "X" ? @current_player = "human" : @current_player = "computer"
    other_player = human? ? "computer" : "human"
    @x_or_o = {@current_player => "X", other_player => "O"}
    @ai = AI.new(board, x_or_o)
    before_game
  end

  def before_game
    puts "-----------------------"
    puts "Tic-tac-toe"
    puts "-----------------------"
    puts human? ? "You are going first!" : "You are going second!"
  end

  def start_game
    until @board.is_game_over?
      next_turn
    end
    game_over
  end

  def next_turn
    display_player_turn
    @board.draw_board
    move = human? ? get_player_choice : @ai.decide_move
    @board.make_move(move, x_or_o[@current_player])
    switch_player
  end

  def display_player_turn
    puts human? ? "Your turn" : "Computer's turn"
  end

  def get_player_choice
    puts "Choose where to place an #{x_or_o[@current_player]} (1 - 9):"
    choice = gets.chomp.to_i
    choice = get_player_choice unless choice.between?(1, 9)
    return choice
  end

  def switch_player
    @current_player = human? ? "computer" : "human"
  end

  def human?
    @current_player == "human"
  end

  def game_over
    @board.draw_board
    puts "-----------------------"
    puts @board.tie_game? ? tie_screen : win_lose_screen
    puts "-----------------------"
  end

  def tie_screen
    "Tie game!"
  end

  def win_lose_screen
    human? ? "You lost!" : "You win!"       # backwards because switch players
  end
end

class Board
  attr_accessor :moves

  def initialize
    @moves = Hash.new("-")
    @wins = [
          [1, 2, 3], [4, 5, 6], [7, 8, 9],  # Horizontal wins
          [1, 4, 7], [2, 5, 8], [3, 6, 9],  # Vertical wins
          [1, 5, 9], [3, 5, 7]              # Diagonal wins
    ]
  end

  def draw_board
    (1..9).each_slice(3) do |x, y, z|
      puts "\t #{@moves[x]} | #{@moves[y]} | #{@moves[z]} "
      puts "\t---+---+---" if x < 7
    end
  end

  def make_move(move, x_or_o)
    @moves[move] = x_or_o
  end

  def evaluate(ai_x_or_o)
    if tie_game?
      return 0
    end

    if ai_x_or_o == "X"
      if x_win?
        return 1
      else
        return -1
      end
    else
      if o_win?
        return 1
      else
        return -1
      end
    end
  end

  def is_game_over?
    win_or_lose? || tie_game?
  end

  def win_or_lose?
    x_win? || o_win?
  end

  def x_win?
    x_keys = @moves.select { |k, v| v == "X" }.keys
    @wins.any? { |w| (w - x_keys).empty? }
  end

  def o_win?
    o_keys = @moves.select { |k, v| v == "O" }.keys
    @wins.any? { |w| (w - o_keys).empty? }
  end

  def tie_game?
    @moves.length == 9 unless win_or_lose?
  end
end

class AI
  attr_reader :x_or_o

  def initialize(board, x_or_o)
    @board = board
    @x_or_o = x_or_o
  end

  def decide_move
    new_board = Marshal.load(Marshal.dump(@board))
    best_score, best_move = minimax(new_board, "computer")
    return best_move
  end

  def minimax(board, player)
    if board.is_game_over?
      return board.evaluate(@x_or_o["computer"]), 0
    end

    best_move = 0
    best_score = computer?(player) ? -100 : 100
    open_moves = get_open_moves(board)
    open_moves.each do |move|
      new_board = Marshal.load(Marshal.dump(board))
      new_board.make_move(move, @x_or_o[player])
      score = minimax(new_board, next_player(player)).first
      if computer?(player)
        best_score, best_move = score, move if score > best_score   # max
      else
        best_score, best_move = score, move if score < best_score   # min
      end
    end

    return best_score, best_move
  end

  def next_player(player)
    computer?(player) ? "human" : "computer"
  end

  def get_open_moves(board)
    (1..9).reject { |i| board.moves.include?(i) }
  end

  def computer?(player)
    player == "computer"
  end
end

game = Game.new
game.start_game
