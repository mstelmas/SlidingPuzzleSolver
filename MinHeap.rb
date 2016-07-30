class MinHeap
  attr_reader :size

  def initialize
    @heap = Array.new(1)
    @size = 0
  end

  def empty?
    @size == 0
  end

  def min
    raise 'Min Heap is empty' if empty?
    @heap[1]
  end

  def del_min
    raise 'Min Heap is empty' if empty?

    min_value = min

    swap!(1, @size)
    @heap.pop
    @size -= 1
    heapify(1)

    min_value
  end

  def insert(element)
    @heap << element
    @size += 1
    swim(@size)
  end

  def check_ri?
    raise 'Min Heap is empty' if empty?
    _check_ri?(1)
  end

  private

  def parent(index)
    index >> 1
  end

  def left_child(index)
    index << 1
  end

  def right_child(index)
    (index << 1) + 1
  end

  def swim(index)
    while index > 1 and @heap[parent(index)] > @heap[index] do
      swap!(parent(index), index)
      index = parent(index)
    end
  end

  def heapify(index)
    while left_child(index) <= @size do
      j = left_child(index)

      # pick smaller child to swap parent with
      if j < @size and @heap[j] > @heap[right_child(index)]
        j += 1
      end

      break unless @heap[index] > @heap[j]

      swap!(index, j)
      index = j
    end
  end

  def swap!(x, y)
    @heap[x], @heap[y] = @heap[y], @heap[x]
  end

  def _check_ri?(index)
    return true if index > @size

    left_child = left_child(index)
    right_child = right_child(index)

    return false if left_child <= @size and @heap[index] > @heap[left_child]
    return false if right_child <= @size and @heap[index] > @heap[right_child]

    _check_ri?(left_child) and _check_ri?(right_child)
  end
end
