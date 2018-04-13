class Snake
  include Enumerable

  DIRECTION_UP = :up
  DIRECTION_DOWN = :down
  DIRECTION_LEFT = :left
  DIRECTION_RIGHT = :right

  X_MOVE = {DIRECTION_LEFT => -1, DIRECTION_RIGHT => 1, DIRECTION_UP => 0, DIRECTION_DOWN => 0}
  Y_MOVE = {DIRECTION_LEFT => 0, DIRECTION_RIGHT => 0, DIRECTION_UP => -1, DIRECTION_DOWN => 1}

  attr_reader :body_parts

  def initialize(x, y, direction)
    @dead = false
    @body_parts = [
      {type: :head, x: x, y: y, direction: direction},
      {type: :tail, x: x - X_MOVE[direction], y: y - Y_MOVE[direction], direction: direction},
      {type: :tail, x: x - X_MOVE[direction] * 2, y: y - Y_MOVE[direction] * 2, direction: direction}
    ]
    @grow = 0
  end

  def each(&block)
    @body_parts.each do |part|
      block.call part
    end
  end

  def move
    return false if dead?

    append_tail = nil
    if @grow > 0
      @grow -= 1
      append_tail = @body_parts.last.clone
    end

    @body_parts.each do |part|
      part[:y] += Y_MOVE[part[:direction]]
      part[:x] += X_MOVE[part[:direction]]
    end

    @body_parts << append_tail if append_tail

    # detect self-collision
    die! if @body_parts.rindex { |part| part[:x] == @body_parts.first[:x] and part[:y] == @body_parts.first[:y] } > 0

    (@body_parts.size - 1).times do |idx|
      if idx < @body_parts.size
        @body_parts[@body_parts.size - idx - 1][:direction] = @body_parts[@body_parts.size - idx - 2][:direction]
      end
    end
  end

  def change_direction(new_direction)
    @body_parts.first[:direction] = new_direction
  end

  def die!
    @dead = true
  end

  def dead?
    @dead
  end

  def grow(num)
    @grow += num
  end
end
