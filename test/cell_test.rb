require 'test/unit'
require 'sokoban'

class CellTest < Test::Unit::TestCase
  include Sokoban

  def test_cell_icon
    cell = Cell.new(
      :floor, MovableObject.new(:package), [2,3]
    )
    assert_equal 'o', cell.icon

    cell = Cell.new(
      :storage, MovableObject.new(:guy), [5,5]
    )
    assert_equal '+', cell.icon

    assert_raise(Cell::WallException) do
      Cell.new(
        :wall, MovableObject.new(:guy), [2, 1]
      )
    end
  end
end
