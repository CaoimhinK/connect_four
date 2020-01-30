require "connect_four/player"
require "connect_four/board"

module ConnectFour
  class Game
    def initialize(players)
      @board = Board.new 8, 8
      @players = players
      @turn = 0
      @input_column = nil
    end

    def pass_turn
      @turn = (@turn + 1) % @players.length
    end

    def won?
      check_col = @board.each_column.any? { |column| match_four_in_a_row(column) }

      check_row = @board.each_row.any? { |row| match_four_in_a_row(row) }

      check_diagonals = @board.each_diagonal.any? { |diagonal| match_four_in_a_row(diagonal) }

      check_col or check_row or check_diagonals
    end

    def reset
      @board.reset
    end

    def play_moves(piece, moves)
      @board.play_moves(piece, moves)
    end

    def game_state
      [@board.state, current_player]
    end

    def read_input(input_column_number)
      if @board.in_range? input_column_number
        if not @board.column_full? input_column_number
          @input_column = input_column_number
          error = nil
        else
          error = 1
        end
      else
        error = 2
      end
    end

    def update
      @board.put_piece current_player.piece, @input_column
      @input_column = nil
      if won?
        return 1
      elsif @board.full?
        return 2
      end
      return false
    end

    private

    def current_player
      @players[@turn]
    end

    def match_four_in_a_row(row)
      escaped_player_piece_string = Regexp.escape(current_player.piece)
      four_in_a_row_regex = /(#{escaped_player_piece_string}){4}/
      row_string = row.join
      row_string.match?(four_in_a_row_regex)
    end
  end
end
