class SokobanElement
  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def coordinates
    [@x,@y]
  end

  def self.icon(ch)
    @@objects_by_icon ||= {}
    @@objects_by_icon[ch] = self
    def self.icon
      ch
  end
  
  def self.immobile?; true; end

  def self.which(icon)
    return @@objects_by_icon[icon]
  end
end

module MoveSokobanElement
  def self.immobile?; false; end

  def move(direction)
    case direction
      when :left
        @x-=1
      when :right
        @x+=1
      when :up
        @y+=1
      when :down
        @y-=1
    end
  end
end


class SokobanWall < SokobanElement
  icon '#'
end

class SokobanPackage < SokobanElement
  include MoveSokobanElement
  icon 'o'
end

class SokobanGuy < SokobanElement
  include MoveSokobanElement
  icon '@'
end
  
class SokobanLevel
  def initialize(iterable) #pass in either a string or a file
    @_level_matrix = @_level_matrix_static = {}
    @elements = []
    iterable.each_with_index do |line, i|
      line.split(//).each_with_index do |ch, j|
        soko_element_class = SokobanElement.which(ch)
        unless soko_element_class.nil?
          soko_element = soko_element_class.new(i,j)
          @elements << soko_element
          if soko_element.is_a?(SokobanGuy)
            @guy = soko_element
          end
        end
      end
    end
  end

  def look(direction, element, spaces=1)
    coordinates = case direction
      when :left
        [element.x - spaces, element.y]
      when :right
        [element.x + spaces, element.y]
      when :up
        [element.x, element.y + spaces]
      when :down
        [element.x, element.y - spaces]
      end

    target = nil
    @elements.each do
      if el.coordinates == coordinates
        target = el
        break
      end
    end

    target
  end
end
