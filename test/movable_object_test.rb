require 'test/unit'
require 'sokoban'

class MovableObjectTest < Test::Unit::TestCase
  include Sokoban

  def test_type
    obj = MovableObject.new(:package)
    assert_equal :package, obj.type
  end
end
