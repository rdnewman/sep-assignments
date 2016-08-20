require_relative './hash_item'

class HashClass

  def initialize(size)
    @items = Array.new(size)
    @size = size > 0 ? size : 1
  end

  def []=(key, value)
    idx = index(key, @size)
    item = @items[idx]
    return if item && item.key == key && item.value == value
    while (item) && (item.key != key)
      resize
      idx = index(key, @size)
      item = @items[idx]
    end
    @items[idx] = HashItem.new(key, value)
    puts "size:  #{size}"
    puts "state: #{@items.inspect}"
  end


  def [](key)
    item = @items[index(key, @size)]
    item ? item.value : nil
  end

  def resize
    @size = (@size * 2)

    newitems = Array.new(@size)
    @items.each { |item| newitems[index(item.key, @size)] = item if item }
    @items = newitems
    nil
  end

  # Returns a unique, deterministically reproducible index into an array
  # We are hashing based on strings, let's use the ascii value of each string as
  # a starting point.
  def index(key, size)
    key.each_byte.map{|c| c}.join('').to_i % @size
  end

  # Simple method to return the number of items in the hash
  def size
    @size
  end

end
