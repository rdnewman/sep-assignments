class Node
  attr_accessor :key
  attr_accessor :value

  def initialize(key, value)
    self.key = key
    self.value = value
  end

  def to_s
    "node: {key: #{key}, value: #{value}}"
  end
end
