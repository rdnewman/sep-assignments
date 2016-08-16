class MyStack
  attr_accessor :top

  def initialize
    @stack = Array.new
    self.top = nil
  end

  def push(item)
    @stack.unshift(item)   # or did you want me to do it via element numbers without using shift/unshift as in "@stack = [item] + @stack"
    refresh
  end

  def pop
    result = @stack.shift   # or did you want me to do it via element numbers without using shift/unshift as in "result = @stack[0]; @stack = @stack[1...-1]"
    refresh
    result
  end

  def empty?
    @stack.length < 1
  end

  def refresh
    self.top = @stack[0]
  end
  private :refresh

end
