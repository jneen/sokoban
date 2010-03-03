SOKOBAN_ICONS = {
  :guy => '@'
  :package => 'o'
  :floor => ' ',
  :wall => '#'
  :storage => '.'
  :storage_with_guy => '+'
  :storage_with_package => '*'
}


class SokobanElement #movable objects on the board
  attr_accessor :x, :y 

  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
  end

  def coordinates
    @coordinates ||= [@x, @y]
  end
  
  def icon
    SOKOBAN_ICONS[@type]
  end

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

class SokobanCell # elements of the level's floor plan
  attr_reader :type, :icon

  class WallException < Error #raised whenever you try to move onto a wall
  end

  def initialize(icon, contents=nil)
    @type, @contents = case icon
      when SOKOBAN_ICONS[:floor]: :floor, nil
      when SOKOBAN_ICONS[:storage]: :storage, nil
      when SOKOBAN_ICONS[:wall]: :wall, nil
      when SOKOBAN_ICONS[:storage_with_guy]: :storage, SokobanElement.new(:guy)
      when SOKOBAN_ICONS[:storage_with_package]: :storage, SokobanElement.new(:package)
    end
    @contents ||= contents
  end

  def open?
    if @type == :wall; return false; end
    if @contents.nil?; return true; end
    return false

  def empty!
    @contents = nil
  end

  def contents; @contents; end
  def contents=(element)
    if !element.nil? and @type == :wall
      raise WallException
    end
    @contents = element
  end
  
  def icon
    if @contents.nil?
      SOKOBAN_ICONS[@type]
    else
      SOKOBAN_ICONS[(@type.to_s + '_with_' + @contents.type.to_s).intern]
    end
  end

end

class SokobanLevel
  def initialize(iterable) #pass in either a string or a file
    @elements = []
    @map = iterable.map do |line|
      line.chomp.split(//).map do |ch|
        ch
      end
    end
  end

  def to_s
    @map.map do |row|
      row.join + "\n"
    end.join
  end

  def look(direction, element, spaces=1)
    case direction
      when :left    : @map[element.x - spaces][element.y]
      when :right   : @map[element.x + spaces][element.y]
      when :up      : @map[element.x][element.y + spaces]
      when :down    : @map[element.x][element.y - spaces]
    end
  end



  end
end

level = SokobanLevel.new(File.foreach(ARGV.first))
puts level.to_s
