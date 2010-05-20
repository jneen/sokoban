require 'test/unit'
require 'sokoban'

class BoardTest < Test::Unit::TestCase
  include Sokoban

  def setup
    @board = new_board_from_file('easy.skn')
  end

  def test_board_parser
    expected_board = "#####\n" +
                     "#.o@#\n" +
                     "#####"
    assert_equal expected_board, @board.to_s
  end

  def test_win
    assert !@board.win?
    @board.push(:left)
    expected_board = "#####\n" +
                     "#*@ #\n" +
                     "#####"
    assert @board.win?
    assert_equal expected_board, @board.to_s
  end
  
  def test_storage_cells
    cells = @board.storage_cells
    cell = cells.first
    assert_equal 1, cells.size
    assert_equal [1, 1], cell.coordinates
    assert_nil cell.contents
    @board.push(:left)
    assert cell.contents
    assert_equal :package, cell.contents.type
  end
end
