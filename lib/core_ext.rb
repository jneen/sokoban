module Enumerable
  def map_with_index
    new_array = []
    each_with_index do |item, index|
      new_array << yield(item, index)
    end
    new_array
  end
end

class Symbol
  def to_proc
    lambda do |object|
      object.send(self)
    end
  end
end

