require_relative 'node'

# This version can handle any of three hashing strategies.
# The dedicated versions are likely faster because of reduced method calls
# and reduced use of enumerators (in the case of linear hashing)

class OpenAddressing
  attr_reader :size

  def initialize(size, strategy = :linear_probing)
    @size = size > 0 ? size : 1
    @items = Array.new(@size)
#  strategy = :double_hashing
#  strategy = :quadratic_probing
    @enumerator_method_name = (strategy.to_s + '_enumerator').to_sym
  end

  def []=(key, value)
    enum = index_enumerator(key, @size)

    idx = enum.next
    item = @items[idx]

    return if item && item.key == key && item.value == value

    while item && item.key != key
      idx = enum.next
      if idx == -1
        resize
        idx = next_open_index(idx, key)
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
    key ? key.sum % (size || @size) : 0
  end

  # Given an index, find the next open index in @items
  def next_open_index(index, key = nil)
    index_enumerator(key, @size).each do |potential|
      is_open = @items[potential].nil? || @items[potential].key == key
      return potential if is_open
    end
    -1  # if no open slots
  end

=begin
  # [THIS VERSION SEEMS SAFER BUT THE TESTS PASS WITHOUT THE EXTRA CHECKING AND
  #  IT'S FASTER/SMALLER WITHOUT THIS CHECKING, BUT I DOUBT IT WOULD WORK
  #  FOR NON-LINEAR PROBING IN LARGER TABLES WITHOUT A VARIATION OF THIS APPORACH]
  require 'set'
  # Given an index, find the next open index in @items
  def next_open_index(index, key = nil)
    tried = Set.new
    index_enumerator(key, @size).each do |potential|
      if tried.include? potential
        return -1
      else
        tried << potential
        is_open = @items[potential].nil? || @items[potential].key == key
        return potential if is_open
      end
    end
    -1  # if no open slots
  end
=end

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

private
  def index_enumerator(key, size_arg = nil)
    size = size_arg || @size
    self.send(@enumerator_method_name, key, size)
  end

  def linear_probing_enumerator(key, size)
    idx = key ? key.sum % size : 0
    Enumerator.new do |y|
      (idx..(size + idx - 1)).each do |i|
        y << i % size
      end
    end
  end

  def quadratic_probing_enumerator(key, size)
    idx = key ? key.sum % size : 0
    Enumerator.new do |y|
      y << idx
      1.upto(size) do |i|
        y << (idx + (i ** i)) % size
      end
    end
  end

  def double_hashing_enumerator(key, size)
    hashcode = key ? key.sum : 0
    idx = hashcode % size

    prime = 1
    [2, 3, 5, 7, 13, 23, 53, 97, 193, 389].each do |i|
      if i < size
        prime = i
      else
        break
      end
    end
    hash2 = ->(hc_arg){prime - (hc_arg % prime) }

    Enumerator.new do |y|
      y << idx
      1.upto(size || @size) do |i|
        y << (idx + (i * hash2.call(hashcode))) % size
      end
    end
  end


end
