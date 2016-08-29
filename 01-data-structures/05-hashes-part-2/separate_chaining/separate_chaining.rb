require_relative 'linked_list'

class SeparateChaining
  attr_reader :max_load_factor

  def initialize(size)
    @items = Array.new(size)
    @item_count = 0
    @max_load_factor = 0.7

    @orig_size = size
    @resizings = 0
  end

  def []=(key, value)
    i = index(key, @items.size)
    n = Node.new(key, value)

    # COLLISION!
    list = @items[i] ? @items[i] : LinkedList.new
    list.add_to_tail(n)

    @items[i] = list
    @item_count = @item_count + 1

    # Resize the hash if the load factor grows too large
    if load_factor.to_f > max_load_factor.to_f
      resize
    end
  end

  def [](key)
    list = @items.at(index(key, @items.size))
    if list != nil
      curr = list.head
      while curr != nil
        if curr.key == key
          return curr.value
        end
        curr = curr.next
      end
    end
  end

  # Returns a unique, deterministically reproducible index into an array
  # We are hashing based on strings, let's use the ascii value of each string as
  # a starting point.
  def index(key, size)
    sum = 0

    key.split("").each do |char|
      if char.ord == 0
        next
      end

      sum = sum + char.ord
    end

    sum % size
  end


  # Display current state of hash
  def print
    puts self
  end

  def to_s
    result = []
    result << "#{@resizings} resizes so far"
    result << "size: #{size} (= #{@orig_size} * 2**#{@resizings})"
    result << "load factor: #{load_factor.round(2)}"
    result += @items.map.with_index do |item, idx|
      "#{idx}: #{item ? item.to_s : '(empty)'}"
    end
    result.join("\n")
  end

  # Calculate the current load factor
  def load_factor
    @item_count / self.size.to_f
  end

  # Simple method to return the number of items in the hash
  def size
    @items.size
  end

  # Resize the hash
  def resize
    @resizings += 1
    new_size = size * 2
    new_items = Array.new(new_size)

    @items.each do |chain|
      if chain
        chain.each_duped do |item|   # need to use new copies so that enumeration works properly when reassigning into new linked lists
          idx = index(item.key, new_size)
          new_items[idx] = LinkedList.new unless new_items[idx]
          new_items[idx].add_to_tail(item)
        end
      end
    end
    @items = new_items

    nil
  end
end
