require 'test/unit'
require 'sokoban'

class ParserTest < Test::Unit::TestCase
  include Sokoban

  def test_parsing_cell_guy
    type, content = Parser.parse_cell('@')
    assert_equal :floor, type
    assert_equal :guy, content.type
  end

  def test_parsing_cell_package
    type, content = Parser.parse_cell('o')
    assert_equal :floor, type
    assert_equal :package, content.type
  end

  def test_parsing_cell_floor
    type, content = Parser.parse_cell(' ')
    assert_equal :floor, type
    assert_nil content
  end
  
  def test_parsing_cell_wall
    type, content = Parser.parse_cell('#')
    assert_equal :wall, type
    assert_nil content
  end

  def test_parsing_cell_storage
    type, content = Parser.parse_cell('.')
    assert_equal :storage, type
    assert_nil content
  end

  def test_parsing_cell_storage_with_package
    type, content = Parser.parse_cell('*')
    assert_equal :storage, type
    assert_equal :package, content.type
  end

  def test_parsing_cell_storage_with_guy
    type, content = Parser.parse_cell('+')
    assert_equal :storage, type
    assert_equal :guy, content.type
  end
end
