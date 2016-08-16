class Node
  attr_accessor :next
  attr_accessor :data

  def initialize(data)
    self.data = data
  end

  # WARNING: this recursive technique only works up to certain list sizes before it goes too deep
  # If to be used for 8K to 10K elements or more, convert the tail recursion to a direct loop in linked_list
  def print
    puts data
    self.next.print if self.next
  end

  # WARNING: this recursive technique only works up to certain list sizes before the search goes too deep
  # If to be used for 8K to 10K elements or more, convert the tail recursion to a direct loop in linked_list
  def find(target_node, previous_node = nil)
    return {found: self, previous: previous_node} if self.equal? target_node
    return self.next.find(target_node, self) if self.next
    {found: nil, previous: previous_node}
  end
end
