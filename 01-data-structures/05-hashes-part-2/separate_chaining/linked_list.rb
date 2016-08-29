require_relative 'node'

# refactored a bit from Assignment #3 to have some fun with Enumerable; also faster now
class LinkedList
  include Enumerable

  attr_accessor :head
  attr_accessor :tail

  def initialize
    @head = nil
    @tail = nil
  end

  # This method creates a new `Node` using `data`, and inserts it at the end of the list.
  def add_to_tail(node)
    return unless node
    @head ||= node
    @tail.next = node if @tail
    @tail = node
    @tail.next = nil    # just to assure node doesn't already have a next
  end

  # This method removes the last node in the lists and must keep the rest of the list intact.
  def remove_tail
    previous_node = previous_to(@tail)
    @head = nil unless previous_node
    @tail = previous_node
    @tail.next = nil if @tail
  end

  # This method prints out a representation of the list.
  def print
    puts self
  end

  def to_s
    self.map.with_index do |item, idx|
      "[#{idx}#{" (HEAD)" if idx == 0}]: #{item ? item : '(empty)'}"
    end.join('; ')
  end

  # This method removes `node` from the list and must keep the rest of the list intact.
  def delete(node)
    if @head.equal? node
      remove_front
    elsif @tail.equal? node
      remove_tail
    else
      previous_node = previous_to(node)
      previous_node.next = node.next if previous_node
    end
  end

  # This method adds `node` to the front of the list and must set the list's head to `node`.
  def add_to_front(node)
    return unless node
    node.next = @head
    @head = node
    @tail = @head unless @tail
  end

  # This method removes and returns the first node in the Linked List and must set Linked List's head to the second node.
  def remove_front
    @head = @head ? @head.next : nil
    @tail = nil unless @head
  end




  def each(&block)
    return enum_for(:each) unless block_given?

    node = @head
    while node do
      yield node
      node = node.next
    end
  end

  def each_duped(&block)
    return enum_for(:each_duped) unless block_given?

    self.each do |node|
      tmp = node.dup
      tmp.next = nil
      yield tmp
    end
  end

  def each_with_previous(&block)
    return enum_for(:each_with_previous) unless block_given?

    curr_node = @head
    prev_node = nil
    while curr_node do
      yield curr_node, prev_node
      curr_node, prev_node = curr_node.next, curr_node
    end
  end

  def previous(node)
    return nil unless node
    self.each_with_previous do |curr_node, prev_node|
      return prev_node if curr_node.equal? node
    end
    nil
  end
  alias_method :previous_to, :previous

end
