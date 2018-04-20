class Snake
  include Enumerable

  DIRECTION_UP = :up
  DIRECTION_DOWN = :down
  DIRECTION_LEFT = :left
  DIRECTION_RIGHT = :right

  X_MOVE = {DIRECTION_LEFT => -1, DIRECTION_RIGHT => 1, DIRECTION_UP => 0, DIRECTION_DOWN => 0}
  Y_MOVE = {DIRECTION_LEFT => 0, DIRECTION_RIGHT => 0, DIRECTION_UP => -1, DIRECTION_DOWN => 1}

  HEAD = Struct.new('Head', :x, :y, :direction)
  TAIL = Struct.new('Tail', :x, :y)

  attr_reader :body_parts

  def initialize(x, y, direction)
    @dead = false
    @body_parts = [
      HEAD.new(x, y, direction),
      TAIL.new(x - X_MOVE[direction], y - Y_MOVE[direction]),
      TAIL.new(x - X_MOVE[direction] * 2, y - Y_MOVE[direction] * 2)
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

    if @grow > 0
      @grow -= 1
      @body_parts << TAIL.new(@body_parts.last.x, @body_parts.last.y)
    end

    (1..@body_parts.size).reverse_each do |idx|
      idx -= 1
      part = @body_parts[idx]

      if TAIL === part
        # detect self-collision
        die! if part.x == @body_parts.first.x and part.y == @body_parts.first.y

        part.x, part.y = [@body_parts[idx - 1].x, @body_parts[idx - 1].y]
      else
        part.x, part.y = [part.x + X_MOVE[part.direction], part.y + Y_MOVE[part.direction]]
      end
    end
  end

  def change_direction(new_direction)
    @body_parts.first.direction = new_direction
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
