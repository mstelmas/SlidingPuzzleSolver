class PuzzleState
  include Comparable

  attr_reader :step, :prev_state, :board

  SOLVED_BOARD = [1, 2, 3, 4, 5, 6, 7, 8]
  VALID_BOARD_SIZE = 9

  # MANHATTAN_DISTANCES[value, position] => manhattan distance
  MANHATTAN_DISTANCES = {
      [1, 0] => 0, [1, 1] => 1, [1, 2] => 2, [1, 3] => 1, [1, 4] => 2, [1, 5] => 3, [1, 6] => 2, [1, 7] => 3, [1, 8] => 4,
      [2, 0] => 1, [2, 1] => 0, [2, 2] => 1, [2, 3] => 2, [2, 4] => 1, [2, 5] => 2, [2, 6] => 3, [2, 7] => 2, [2, 8] => 3,
      [3, 0] => 2, [3, 1] => 1, [3, 2] => 0, [3, 3] => 3, [3, 4] => 2, [3, 5] => 1, [3, 6] => 4, [3, 7] => 3, [3, 8] => 2,
      [4, 0] => 1, [4, 1] => 2, [4, 2] => 3, [4, 3] => 0, [4, 4] => 1, [4, 5] => 2, [4, 6] => 1, [4, 7] => 2, [4, 8] => 3,
      [5, 0] => 2, [5, 1] => 1, [5, 2] => 2, [5, 3] => 1, [5, 4] => 0, [5, 5] => 1, [5, 6] => 2, [5, 7] => 1, [5, 8] => 2,
      [6, 0] => 3, [6, 1] => 2, [6, 2] => 1, [6, 3] => 2, [6, 4] => 1, [6, 5] => 0, [6, 6] => 3, [6, 7] => 2, [6, 8] => 1,
      [7, 0] => 2, [7, 1] => 3, [7, 2] => 4, [7, 3] => 1, [7, 4] => 2, [7, 5] => 3, [7, 6] => 0, [7, 7] => 1, [7, 8] => 2,
      [8, 0] => 3, [8, 1] => 2, [8, 2] => 3, [8, 3] => 2, [8, 4] => 1, [8, 5] => 2, [8, 6] => 1, [8, 7] => 0, [8, 8] => 1
  }

  def initialize(board, step = 0, prev_state = nil)
    raise 'Not a valid board size (3x3 required!)' unless board.size == VALID_BOARD_SIZE
    @board = board
    @step = step
    @prev_state = prev_state
  end

  def generate_states
    states = Array.new

    zero_position_index = zero_position

    states << create_state(zero_position_index - 3, zero_position_index) if zero_position_index / 3 > 0
    states << create_state(zero_position_index + 3, zero_position_index) if zero_position_index / 3 < 2
    states << create_state(zero_position_index - 1, zero_position_index) if zero_position_index % 3 > 0
    states << create_state(zero_position_index + 1, zero_position_index) if zero_position_index % 3 < 2

    if self.prev_state.nil?
      states
    else
      states.select { |state| not self.prev_state == state }
    end
  end

  def manhattan_distance
    manhattan_dist = 0

    @board.each_index { |i| manhattan_dist += MANHATTAN_DISTANCES[[@board[i], i]] unless @board[i].zero? }

    manhattan_dist + @step
  end

  def solved?
    invalid_positions == 0
  end

  def <=>(other)
    self.manhattan_distance - other.manhattan_distance
  end

  def ==(other)
    self.board == other.board
  end

  def to_s
    board_rep = String.new

    @board.each_index do |i|
      if @board[i].zero?
        board_rep << '   '
      else
        board_rep << " #{@board[i]} "
      end
      board_rep << "\n" if i.succ % 3 == 0
    end
    board_rep
  end

  private

  def zero_position
    @board.each_index do |i|
      return i if @board[i].zero?
    end
    raise 'Board is in invalid state (no free space available)'
  end

  def invalid_positions
    m = 0
    SOLVED_BOARD.each_index { |i| m += 1 unless @board[i] == SOLVED_BOARD[i] }
    m
  end

  def create_state(from_pos, to_pos)
    board_copy = Array.new(@board)

    board_copy[to_pos] = board_copy[from_pos]
    board_copy[from_pos] = 0

    PuzzleState.new(board_copy, @step + 1, self)
  end
end
