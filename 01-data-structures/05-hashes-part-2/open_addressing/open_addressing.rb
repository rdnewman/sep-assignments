require_relative 'node'

class OpenAddressing
  attr_reader :size

  def initialize(size)
    @size = size > 0 ? size : 1
    @items = Array.new(@size)
  end

  def []=(key, value)
    idx = index(key)
    item = @items[idx]

    return if item && item.key == key && item.value == value

    while item && item.key != key
      idx = next_open_index(idx)
      if idx == -1
        resize
        idx = next_open_index(idx)
        @items[idx] = Node.new(key, value)
        return @items[idx]
      end
      item = @items[idx]
    end

    if item && item.key == key
      @items[idx].value = value
    else
      @items[idx] = Node.new(key, value)
    end
  end

  def [](key)
    idx = index(key)
    item = @items[idx]
    while item && item.key != key
      idx = (idx + 1) % size
      item = @items[idx]
    end
    item ? item.value : nil
  end

  # Returns a unique, deterministically reproducible index into an array
  # We are hashing based on strings, let's use the ascii value of each string as
  # a starting point.
  def index(key, size = nil)
    key.sum % (size ? size : @size)
  end

  # Given an index, find the next open index in @items
  def next_open_index(index, key = nil)
    # wraps through all elements starting at given index
    (index..(@size + index - 1)).each do |i|
      potential = i % @size
      is_open = @items[potential].nil? || @items[potential].key == key
      return potential if is_open
    end
    -1  # if no open slots
  end

  # Resize the hash
  def resize
    @size = @size * 2

    newitems = Array.new(@size)
    @items.each do |item|
      newitems[index(item.key, @size)] = item if item
    end
    @items = newitems
    nil
  end

  # Display current state of hash
  def print
    puts "size: #{size}"
    @items.each_with_index do |item, idx|
      if item
        puts "#{idx}: #{item}"
      end
    end
  end

end
