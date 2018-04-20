class KeyboardReader
  def self.read
    input = STDIN.read_nonblock(1) rescue nil
    if input == "\e"
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
    input
  end
end