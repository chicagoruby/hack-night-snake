require 'io/console'

STDIN.echo = false
STDIN.raw!

class KeyboardReader
  def self.read
    input = STDIN.read_nonblock(1) rescue nil
    if input == "\e"
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
    if input == 'q'
      STDIN.echo = true
      STDIN.cooked!
      exit!
    end
    input
  end
end

class Snake
  include Enumerable

  DIRECTION_UP = :up
  DIRECTION_DOWN = :down
  DIRECTION_LEFT = :left
  DIRECTION_RIGHT = :right

  attr_reader :body_parts

  def initialize(x, y, length)
    @dead = false
    @body_parts = [
      {type: :head, x: x, y: y, direction: DIRECTION_LEFT}
    ]
    (length-1).times do |i|
      @body_parts << {type: :tail, x: x + i + 1, y: y, direction: DIRECTION_LEFT}
    end
  end

  def each(&block)
    @body_parts.each do |part|
      block.call part
    end
  end

  def move
    return false if dead?
    @body_parts.each do |part|
      case part[:direction]
        when Snake::DIRECTION_UP
          part[:y] -= 1
        when Snake::DIRECTION_DOWN
          part[:y] += 1
        when Snake::DIRECTION_LEFT
          part[:x] -= 1
        when Snake::DIRECTION_RIGHT
          part[:x] += 1
      end
    end

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
end

class Grid

  def initialize(width, height)
    @width = width
    @height = height
  end

  # @param [Snake] snake
  def render(snake)
    rows = []
    @height.times do |i|
      if i == 0
        rows << '—' * (@width + 2)
      end
      rows << '|' + ' ' * @width + '|'
      if i == @height - 1
        rows << '—' * (@width + 2)
      end
    end

    unless snake.dead?
      snake.each do |part|
        if part[:y] < 1 or part[:x] < 1 or part[:y] > @height or part[:x] > @width
          snake.die!
          break
        end
        rows[part[:y]][part[:x]] = {head: '@', tail: '*'}[part[:type]]
      end
    end

    if snake.dead?
      rows[@height / 2][@width / 2 - 4 .. @width / 2 + 4] = 'GAME OVER'
    end

    output = rows.join "\r\n"
    output << "\r\npress \"q\" to quit"
    output
  end

end

class Game

  KEYSTROKES = {
    "\e[C" => Snake::DIRECTION_RIGHT,
    "\e[A" => Snake::DIRECTION_UP,
    "\e[B" => Snake::DIRECTION_DOWN,
    "\e[D" => Snake::DIRECTION_LEFT
  }

  def initialize
    @grid = Grid.new(30, 30)
    @snake = Snake.new(13, 15, 3)
  end

  def run!
    loop do

      puts "\e[H\e[2J"

      input = KeyboardReader.read
      @snake.change_direction KEYSTROKES[input] if KEYSTROKES.has_key? input
      @snake.move
      puts @grid.render(@snake)
      sleep 0.2

    end

  end
end

game = Game.new
game.run!