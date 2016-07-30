require_relative 'PuzzleState'
require_relative 'MinHeap'

class Solver
  def solve(starting_state)
    min_pq = MinHeap.new
    min_pq.insert(starting_state)

    until min_pq.min.solved?
      min_pq.del_min.generate_states.each { |state| min_pq.insert(state) }
    end
    min_pq.min
  end
end

def create_traceback_stack(starting_state)
  tb_stack = Array.new
  tb_stack.push(starting_state)

  current_state = starting_state.prev_state
  until current_state.nil? do
    tb_stack.push(current_state)
    current_state = current_state.prev_state
  end

  tb_stack
end

=begin
Sample board:
  4 0 7
  5 1 3
  6 8 2
=end
starting_state = PuzzleState.new([4, 0, 7, 5, 1, 3, 6, 8, 2])

puts "Searching for a solution for: \n#{starting_state}\n"

solved_state = Solver.new.solve(starting_state)

tb_stack = create_traceback_stack(solved_state)
puts "Solution can be reached in #{tb_stack.size - 1} steps"

until tb_stack.empty? do
  print "#{tb_stack.pop}\n"
end
