#!/usr/bin/env ruby

require 'benchmark'
require_relative 'linked_list'

COMPARISONS = [
  'Compare the time it takes to create a 10,000 item Array to appending 10,000 items to a Linked List.',
  'Compare the time it takes to access the 5000th element of the Array and the 5000th Node in the Linked List.',
  'Compare the time it takes to remove the 5000th element from the Array to removing the 5000th Node in the Linked List. In the Array, the 5001st item becomes the 5000th, and so on.'
]
SIZE = 10000


# Compare the time it takes to create a 10,000 item Array to appending 10,000 items to a Linked List.
def compare1
  Benchmark.bmbm do |trial|
    trial.report("create #{SIZE} item array") do
      (SIZE/100).times do
        Array.new(SIZE){Node.new(random)}
      end
    end

    trial.report("create #{SIZE} item linked list") do
      (SIZE/100).times do
        list = LinkedList.new
        SIZE.times{ list.add_to_tail(Node.new(random)) }
      end
    end
  end
end

#Compare the time it takes to access the 5000th element of the Array and the 5000th Node in the Linked List.
def compare2
  target = SIZE/2

  array = Array.new(SIZE){Node.new(random)}

  list = LinkedList.new
  (target-1).times{ list.add_to_tail(Node.new(random)) }
  target_node = Node.new(random)
  list.add_to_tail(target_node)
  target.times{ list.add_to_tail(Node.new(random)) }

  Benchmark.bm do |trial|
    trial.report("find #{target}th item in array      ") do
      SIZE.times do
        array[target]
      end
    end

    trial.report("find #{target}th item in linked list") do
      SIZE.times do
        list.find(target_node)
      end
    end
  end
end

#Compare the time it takes to remove the 5000th element from the Array to removing the 5000th Node in the Linked List. In the Array, the 5001st item becomes the 5000th, and so on.
def compare3
  target = SIZE/2

  array = Array.new(SIZE){Node.new(random)}

  list = LinkedList.new
  (target-1).times{ list.add_to_tail(Node.new(random)) }
  target_node = Node.new(random)
  list.add_to_tail(target_node)
  target.times{ list.add_to_tail(Node.new(random)) }

  # can only do once since restoring the deleted item would cost irrelevant time
  Benchmark.bm do |trial|
    trial.report("delete #{target}th item in array      ") do
      array[0..(target-2)] + array[target..-1]
    end

    trial.report("delete #{target}th item in linked list") do
      list.delete(target_node)
    end
  end
end

def random
  rand(0...SIZE).to_i
end

COMPARISONS.each_with_index do |comparison, idx|
  puts
  puts "="*40
  puts comparison
  puts
  self.send("compare#{idx+1}".to_sym)
end
