module Enumerable
  def map_with_index
    new_array = []
    each_with_index do |item, index|
      new_array << yield(item, index)
    end
    self
  end
end

module Sokoban
  ICONS = {
    :guy                  => '@',
    :package              => 'o',
    :floor                => ' ',
    :wall                 => '#',
    :storage              => '.',
    :storage_with_guy     => '+',
    :storage_with_package => '*'
  }

  class MovableObject #movable objects on the board
    attr_accessor :x, :y 

    def initialize(type)
      @type = type
    end

    def coordinates
      [@x, @y]
    end

    def coordinates=(value)
      @x, @y = value
    end
    
    def icon
      ICONS[@type]
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

  class Cell # elements of the level's floor plan
    attr_reader :type

    class WallException < Error #raised whenever you try to move onto a wall
    end

    def initialize(icon, coordinates)
      @type, @contents = case icon
        when ICONS[:floor]:                :floor,   nil
        when ICONS[:wall]:                 :wall,    nil
        when ICONS[:storage]:              :storage, nil
        when ICONS[:storage_with_guy]:     :storage, MovableObject.new(:guy)
        when ICONS[:storage_with_package]: :storage, MovableObject.new(:package)
        when ICONS[:guy]:                  :floor,   MovableObject.new(:guy)
        when ICONS[:package]:              :floor,   MovableObject.new(:package)
      end
      @coordinates = coordinates
      @content.coordinates = coordinates if @content
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

  class Level
    def initialize(iterable) #pass in either a string or a file iterable
      @elements = []
      @map = iterable.map_with_index do |line, row|
        line.chomp.split(//).map_with_index do |ch, col|
          Cell.new(ch, [row, column])
        end
      end
    end

    def to_s
      @map.map do |row|
        row.join + "\n"
      end.join
    end

    def look(cell, direction, spaces=1)
      case direction
        when :left    : @map[element.x - spaces][element.y]
        when :right   : @map[element.x + spaces][element.y]
        when :up      : @map[element.x][element.y + spaces]
        when :down    : @map[element.x][element.y - spaces]
      end
    end

    # will move an element in one direction.
    # will do nothing if the square is not open.
    def move(cell, direction)
      target = look element, direction
      if target.open?
        target.contents = element
        #TODO: how do i get the cell containing element?  ...or at least clear it.
      end
    end

    def push(direction)
      adjacent = look @guy direction

    end
  end

  level = Level.new(File.foreach(ARGV.first))
  puts level.to_s
end
