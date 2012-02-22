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
    
    assert_equal [[0,0, 24, 24], [20, 0, 20, 24], [0, 20, 24,20], [20, 20, 20 , 20 ]], cutter.get_piece_matrix
  end
  
  def test_return_points_for_a_given_piece
    #note: this is faulty - I think there is not enough overlap.
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
    assert_equal [0,0, 24, 24], cutter.piece_points(0, 0)
    assert_equal [20, 0, 20, 24], cutter.piece_points(1, 0)
    assert_equal [0, 20, 24, 20], cutter.piece_points(0, 1)
    assert_equal [20, 20, 20 , 20 ], cutter.piece_points(1, 1)

    assert_equal [0,0, 20, 20], cutter.piece_points(0, 0, false)
    assert_equal [20, 0, 20, 20], cutter.piece_points(1, 0, false)
    assert_equal [0, 20, 20,20], cutter.piece_points(0, 1, false)
    assert_equal [20, 20, 20 , 20 ], cutter.piece_points(1, 1, false)
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
    
    assert_equal [[10, 22], [22, 10]], cutter.connector_locations(0, 0)
    assert_equal [[30, 22], [22, 10]], cutter.connector_locations(1, 0)
    assert_equal [[10, 22], [22, 30]], cutter.connector_locations(0, 1)
    assert_equal [[30, 22], [22, 30]], cutter.connector_locations(1, 1)
    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 80
    
    assert_equal [[10, 22], [22, 10]], cutter.connector_locations(0, 0)
    assert_equal [[30, 22], [22, 10], [42,10]], cutter.connector_locations(1, 0)
    assert_equal [[50, 22], [42, 10]], cutter.connector_locations(2, 0)
    
    assert_equal [[10,22], [10, 42], [22, 30]], cutter.connector_locations(0, 1)
    assert_equal [[30,22], [30, 42], [22, 30], [42,30]], cutter.connector_locations(1, 1)
    assert_equal [[50,22], [50, 42], [42, 30]], cutter.connector_locations(2, 1)
    
    assert_equal [[10,42], [10, 62], [22, 50]], cutter.connector_locations(0, 2)
    assert_equal [[30,42], [30, 62], [22, 50], [42,50]], cutter.connector_locations(1, 2)    
    assert_equal [[50,42], [50, 62], [42, 50]], cutter.connector_locations(2, 2)
    
    assert_equal [[10,62], [22,70]], cutter.connector_locations(0, 3)    
    assert_equal [[30,62], [22,70], [42,70]], cutter.connector_locations(1, 3)
    assert_equal [[50,62], [42,70]], cutter.connector_locations(2, 3)    
  end
  
  def test_should_determine_connector_type
    # CONNECTOR_TOP_PATTERN = [-1, -1 ,1]
    # CONNECTOR_RIGHT_PATTERN = [1, 1, -1]
    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
   
    assert_equal [nil, -1, nil, 1], cutter.connector_types(0,0)
    assert_equal [nil, -1, -1, nil], cutter.connector_types(1,0)
    assert_equal [1, nil, nil, 1], cutter.connector_types(0,1)
    assert_equal [1, nil, -1, nil], cutter.connector_types(1,1)
  end
end