require 'io/console'
require_relative 'level'
require_relative 'keyboard_reader'

class UserInterrupt < Exception; end

class Game

  KEYSTROKES = {
    "\e[C" => Snake::DIRECTION_RIGHT,
    "\e[A" => Snake::DIRECTION_UP,
    "\e[B" => Snake::DIRECTION_DOWN,
    "\e[D" => Snake::DIRECTION_LEFT
  }

  def initialize
    @level = Level.new('levels/1.txt')
  end

  def run!
    STDIN.echo = false
    STDIN.raw!
    begin
      loop do
        puts "\e[H\e[2J"
        input = KeyboardReader.read
        raise UserInterrupt if input == 'q'
        @level.snake.change_direction KEYSTROKES[input] if KEYSTROKES.has_key? input
        @level.snake.move
        puts @level.render
        sleep 0.2
      end
    rescue Exception => e
      STDIN.echo = true
      STDIN.cooked!
      raise unless UserInterrupt === e
    end
  end
end
