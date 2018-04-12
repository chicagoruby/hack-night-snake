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

  DIRECTION_UP = :up
  DIRECTION_DOWN = :down
  DIRECTION_LEFT = :left
  DIRECTION_RIGHT = :right

  attr_reader :direction

  def initialize(direction = (Snake::DIRECTION_UP))
    @direction = direction
  end

  def handle_keystroke
    input = KeyboardReader.read
    if input
      case input
        when "\e[C"
          @direction = DIRECTION_RIGHT
        when "\e[A"
          @direction = DIRECTION_UP
        when "\e[B"
          @direction = DIRECTION_DOWN
        when "\e[D"
          @direction = DIRECTION_LEFT
      end
    end
  end
end

class Grid

  def initialize(dimensions)
    @matrix = Array.new dimensions do
      Array.new dimensions
    end
  end

  def spawn_snake(x, y)
    @matrix[y][x] = Snake.new
  end

  def render(gameover = false)
    output = ''
    @matrix.each_with_index do |row, index|
      output <<
        if index == 0 or index == @matrix.size - 1
          '-' * (row.size + 2)
        elsif gameover
          ('|' + ' ' * row.size + '|').tap { |str| index == @matrix.size / 2 ? str[str.size / 2 - 4 .. str.size / 2 + 4] = 'GAME OVER' : str }
        else
          '|' + row.map { |cell| cell.nil? ? ' ' : '@' }.join + '|'
        end
      output << "\r\n"
    end
    output << 'press "q" to quit'
    output
  end

  def move
    @matrix.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if Snake === cell

          # @type [Snake]
          snake = cell

          @matrix[y][x] = nil
          case snake.direction
            when Snake::DIRECTION_UP
              y -= 1
            when Snake::DIRECTION_DOWN
              y += 1
            when Snake::DIRECTION_LEFT
              x -= 1
            when Snake::DIRECTION_RIGHT
              x += 1
          end
          raise GameOver.new if y < 0 or x < 0 or y >= @matrix.size or x >= row.size
          @matrix[y][x] = snake
          snake.handle_keystroke
          return
        end
      end
    end
  end
end


class Game
  def initialize
    @grid = Grid.new(30)
    @grid.spawn_snake(15,15)
    @gameover = false
  end

  def run!
    loop do

      puts "\e[H\e[2J"

      if @gameover
        KeyboardReader.read
      else
        begin
          @grid.move
        rescue GameOver
          @gameover = true
        end
      end
      puts @grid.render(@gameover)
      sleep 0.1

    end

  end
end

class GameOver < Exception

end

game = Game.new
game.run!