require 'test/unit'
require 'puzzle_generator/cutter'


class CutterTest < Test::Unit::TestCase
  include PuzzleGenerator
  def test_should_store_size_of_piece
    cutter = Cutter.new
    cutter.piece_size = 20
    assert_equal 20, cutter.piece_size
  end
  
  def test_should_store_size_of_image
    cutter = Cutter.new
    cutter.image_width = 20
    cutter.image_height = 100
    assert_equal 20, cutter.image_width
    assert_equal 100, cutter.image_height
  end
  
  def test_determine_number_of_horizontal_pieces
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 100

    assert_equal 2, cutter.horizontal_pieces
    assert_equal 5, cutter.vertical_pieces
  end
  
  def test_determine_connector_size
    #connector should be 20% or the size of the piece
    cutter = Cutter.new
    cutter.piece_size = 20
    assert_equal 4, cutter.connector_size
  end
  
  def test_should_return_the_4_positions_of_the_first_square
    # the piece need to overlap so that we can correctly match the connectors.
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
    assert_equal [[0,0, 24, 24], [20, 0, 40, 24], [0, 20, 24,40], [20, 20, 40 , 40 ]], cutter.get_piece_matrix
  end
  
  def test_return_points_for_a_given_piece
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
    assert_equal [0,0, 24, 24], cutter.piece_points(0, 0)
    assert_equal [20, 0, 40, 24], cutter.piece_points(1, 0)
    assert_equal [0, 20, 24,40], cutter.piece_points(0, 1)
    assert_equal [20, 20, 40 , 40 ], cutter.piece_points(1, 1)
  end
  
  def test_determine_the_radius_of_the_connector
    cutter = Cutter.new
    cutter.piece_size = 20
    assert_equal 2, cutter.connector_radius
  end
  
  def test_should_return_connector_locations_give_a_piece
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40

    assert_equal [[22, 10], [10, 22]], cutter.connector_locations(0, 0)
    assert_equal [[22, 10], [30, 22]], cutter.connector_locations(1, 0)
    assert_equal [[10, 22], [22, 30]], cutter.connector_locations(0, 1)
    assert_equal [[30, 22], [22, 30]], cutter.connector_locations(1, 1)
  end
end