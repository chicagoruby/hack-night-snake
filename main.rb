require 'io/console'

STDIN.echo = false
STDIN.raw!

class Snake

  DIRECTION_UP =    :up
  DIRECTION_DOWN =  :down
  DIRECTION_LEFT =  :left
  DIRECTION_RIGHT = :right

  attr_reader :direction

  def initialize(direction = (Snake::DIRECTION_UP))
    @direction = direction
  end

end

class Grid

  def initialize(dimensions)
    @grid = Array.new dimensions do
      Array.new dimensions
    end
  end

  def spawn_snake(x, y)
    @grid[y][x] = Snake.new
  end

  def run
    loop do

      puts "\e[H\e[2J"

      reposition_the_snake

      output = ''
      @grid.each_with_index do |row, index|
        if index == 0 or index == @grid.size - 1
          output << '-' * (row.size + 2)
        else
          output << '|' + row.map { |cell| cell.nil? ? '.' : '*' }.join + '|'
        end
        output << "\r\n"
      end

      puts output

      handle_keystroke

      sleep 0.1

    end
  end

  def reposition_the_snake
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if Snake === cell
          snake = cell
          @grid[y][x] = nil
          case cell.direction
            when Snake::DIRECTION_UP
              @grid[y-1][x] = snake
              return
            when Snake::DIRECTION_DOWN
              @grid[y+1][x] = snake
              return
            when Snake::DIRECTION_LEFT
              @grid[y][x-1] = snake
              return
            when Snake::DIRECTION_RIGHT
              @grid[y][x+1] = snake
              return
          end
        end
      end
    end
  end

  def handle_keystroke
    input = STDIN.read_nonblock(1) rescue nil
    if input == "\e"
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
    p input
    if input == 'q'
      STDIN.echo = true
      exit!
    end
  end

end

grid = Grid.new(30)
grid.spawn_snake(10, 10)

grid.run