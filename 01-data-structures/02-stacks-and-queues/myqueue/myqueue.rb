class MyQueue
  attr_accessor :head
  attr_accessor :tail

  def initialize
    @queue = Array.new
    @tail = @head = @queue[0]
  end

  def enqueue(element)
    @queue[@queue.length] = element   # or @queue << element (but assignment prohibuts push for stack so avoiding here too)
    refresh
    @tail
  end

  def dequeue
    result = @queue.shift  # or result = head; @queue = @queue[1..-1]
    refresh
    result
  end

  def empty?
    @queue.length < 1
  end

  def refresh
    @head = @queue[-1]
    @tail = @queue[0]
  end
  private :refresh

end
