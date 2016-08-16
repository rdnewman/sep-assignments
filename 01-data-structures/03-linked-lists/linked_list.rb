require_relative 'node'

class LinkedList
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
    return unless @head && @tail
    result = @head.find(@tail)
    if result[:found]
      @head = nil unless result[:previous]
      @tail = result[:previous]
      @tail.next = nil if @tail
    end
  end

  # This method prints out a representation of the list.
  def print
    @head.print if @head
  end

  # This method removes `node` from the list and must keep the rest of the list intact.
  def delete(node)
    return unless node && @head
    result = @head.find(node)
    if result[:found]
      if result[:previous]   # if not @head
        result[:previous].next = result[:found].next
      else
        @head = result[:found].next
      end
      @tail = result[:previous] if @tail.equal? result[:found]
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

  # this method only exists for benchmarking purposes; it's silly otherwise since one already has the node
  def find(node)
    result = @head.find(node)
    result[:found]
  end
end
