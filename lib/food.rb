class Food
  include Enumerable

  def initialize
    @bites = []
  end

  def each(&block)
    @bites.each do |bite|
      block.call bite
    end
  end

  def spawn(x, y)
    @bites << {x: x, y: y, id: Time.now.to_f.to_s.delete('.').to_i.to_s(36)}
  end

  def any_at?(x, y)
    @bites.find { |bite| bite[:x] == x and bite[:y] == y }
  end

  def eat!(id)
    @bites.delete_if { |bite| bite[:id] == id }
  end
end