require_relative 'snake'
require_relative 'food'

class Level

  attr_reader :snake

  def initialize(source)
    @rows = File.readlines(source)
    @rows.each_with_index do |row, y|
      x = row.index /[UDLR]/
      if x
        @snake = Snake.new(x, y, {
          U: Snake::DIRECTION_UP,
          D: Snake::DIRECTION_DOWN,
          L: Snake::DIRECTION_LEFT,
          R: Snake::DIRECTION_RIGHT
        }[row[x].to_sym])
        row[x] = ' '
      end
    end
    @food = Food.new
  end

  def render
    rows = Marshal.load(Marshal.dump(@rows))
    detect_collision!
    unless @snake.dead?
      feed_snake!

      @snake.each do |part|
        rows[part[:y]][part[:x]] = {head: '@', tail: '*'}[part[:type]]
      end

      spawn_food!

      @food.each do |bite|
        rows[bite[:y]][bite[:x]] = '.'
      end
    end

    if @snake.dead?
      message_row = rows[rows.size / 2]
      message_row[message_row.size / 2 - 4 .. message_row.size / 2 + 4] = 'GAME OVER'
    end

    output = rows.join "\r"
    output << "\r\npress \"q\" to quit\r\n"
    output
  end

  def detect_collision!
    head = @snake.first
    @snake.die! if @rows[head[:y]][head[:x]] != ' '
  end

  def feed_snake!
    head = @snake.first
    bite = @food.any_at?(head[:x], head[:y])
    if bite
      @food.eat! bite[:id]
      @snake.grow 1
    end
  end

  def spawn_food!
    if @food.count == 0
      x = y = 0
      loop do
        y = rand(@rows.size)
        x = rand(@rows[y].size)
        break if @rows[y][x] == ' '
      end
      @food.spawn(x, y)
    end
  end
end