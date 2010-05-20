require 'core_ext'

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
    attr_accessor :type

    def initialize(type)
      @type = type
    end

    def icon
      ICONS[@type]
    end
  end

  class Cell # elements of the level's floor plan
    attr_reader :type, :coordinates, :row, :col

    def coordinates
      [@row,@col]
    end

    def coordinates=(value)
      @row, @col = value
    end

    class WallException < Exception #raised whenever you try to move onto a wall
    end

    def initialize(type, contents, coordinates)
      raise WallException if type == :wall && contents

      @type, @contents = type, contents
      @row, @col = coordinates
    end

    def open?
      if @type == :wall; return false; end
      if @contents.nil?; return true; end
      return false
    end

    def empty!
      @contents = nil
    end

    def contents; @contents; end
    def contents=(element)
      if element && @type == :wall
        raise WallException
      end
      @contents = element
    end

    def inspect
      if @contents
        "<Cell type=#{@type} contents=#{@contents.type}>"
      else
        "<Cell type=#{@type} contents=nil>"
      end
    end
    
    def icon
      if @contents.nil?
        ICONS[@type]
      elsif @type == :floor
        ICONS[@contents.type]
      else
        ICONS[(@type.to_s + '_with_' + @contents.type.to_s).intern]
      end
    end

  end

  module Parser
    def self.parse_board(iterable)
      iterable.map_with_index do |line, row|
        line.chomp.split(//).map_with_index do |ch, col|
          type, content = parse_cell(ch)
          Cell.new(type, content, [row, col])
        end
      end
    end

    def self.parse_cell(ch)
      case ch
        when ICONS[:floor]:                [:floor,   nil                        ]
        when ICONS[:wall]:                 [:wall,    nil                        ]
        when ICONS[:storage]:              [:storage, nil                        ]
        when ICONS[:storage_with_guy]:     [:storage, MovableObject.new(:guy)    ]
        when ICONS[:storage_with_package]: [:storage, MovableObject.new(:package)]
        when ICONS[:guy]:                  [:floor,   MovableObject.new(:guy)    ]
        when ICONS[:package]:              [:floor,   MovableObject.new(:package)]
      end
    end
  end

  class Board
    def initialize(map) 
      @elements = []
      @map = map
    end

    def to_s
      @map.map do |row|
        row.map(&:icon).join + "\n"
      end.join.chomp
    end

    def look(cell, direction)
      row, col = cell.coordinates
      case direction
        when :left    : @map[row][col-1]
        when :right   : @map[row][col+1]
        when :up      : @map[row-1][col]
        when :down    : @map[row+1][col]
      end
    end

    # will move an element in one direction.
    # will do nothing if the square is not open.
    def move(cell, direction)
      return unless cell.contents
      target = look(cell, direction)
      if target.open?
        target.contents = cell.contents
        cell.contents = nil
      end
    end

    def push(direction)
      adjacent = look(guys_cell, direction)
      move(adjacent, direction)
      move(guys_cell, direction)
    end

    def storage_cells
      @storage_cells ||= @map.flatten.select { |cell| cell.type == :storage }
    end

    def guys_cell
      @map.flatten.find { |cell| cell.contents && cell.contents.type == :guy }  
    end

    def win?
      storage_cells.all? do |cell|
        cell.contents && cell.contents.type == :package
      end
    end
  end

  def new_board_from_file(filename)
    Board.new(
      Parser.parse_board(
        File.foreach(filename)
      )
    )
  end

  module Console
    def clear
      puts "\n"*50
    end

    def render
      clear
      p @board.guys_cell.coordinates
      if @board.win?
        puts "!!!!"
      end
      puts @board
    end

    def up
      @board.push(:up)
      render
    end

    def left
      @board.push(:left)
      render
    end

    def right
      @board.push(:right)
      render
    end

    def down
      @board.push(:down)
      render
    end
  end

  def self.install!(me)
    me.send(:include, Sokoban)
    me.send(:include, Sokoban::Console)
    me.instance_variable_set("@board", new_board_from_file('../hard.skn'))
  end
end

