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
  
  def test_determine_connector_radius
    #connector should be 20% or the size of the piece
    cutter = Cutter.new
    cutter.piece_size = 20
    assert_equal 2, cutter.connector_radius
  end
  
  def test_should_return_the_4_positions_of_the_first_square
    # the piece need to overlap so that we can correctly match the connectors.
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
    assert_equal [[0,0, 22, 22], [18, 0, 22, 22], [0, 18, 22,22], [18, 18, 22 , 22]], cutter.get_piece_matrix
  end
  
  def test_return_points_for_a_given_piece
    #note: I think this is faulty - there is not enough overlap.
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
    assert_equal [0,0, 22, 22], cutter.piece_points(0, 0)
    assert_equal [18, 0, 22, 22], cutter.piece_points(1, 0)
    assert_equal [0, 18, 22, 22], cutter.piece_points(0, 1)
    assert_equal [18, 18, 22 , 22 ], cutter.piece_points(1, 1)

    assert_equal [0,0, 20, 20], cutter.piece_points(0, 0, false)
    assert_equal [20, 0, 20, 20], cutter.piece_points(1, 0, false)
    assert_equal [0, 20, 20,20], cutter.piece_points(0, 1, false)
    assert_equal [20, 20, 20 , 20 ], cutter.piece_points(1, 1, false)
    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 60
    
    assert_equal [0,0, 22, 22], cutter.piece_points(0, 0)
    assert_equal [18, 0, 24, 22], cutter.piece_points(1, 0)
    assert_equal [38, 0, 22, 22], cutter.piece_points(2, 0)
    
    assert_equal [0, 18, 22, 24], cutter.piece_points(0, 1)
    assert_equal [18, 18, 24 , 24 ], cutter.piece_points(1, 1)
    assert_equal [38, 18, 22 , 24 ], cutter.piece_points(2, 1)
    
    assert_equal [0, 38, 22 , 22 ], cutter.piece_points(0, 2)
    assert_equal [18, 38, 24 , 22 ], cutter.piece_points(1, 2)
    assert_equal [38, 38, 22 , 22 ], cutter.piece_points(2, 2)
  end
  
  def test_determine_the_radius_of_the_connector
    cutter = Cutter.new
    cutter.piece_size = 20
    assert_equal 2, cutter.connector_radius
  end
  
  def test_should_return_connector_locations_give_a_piece
    
    #       2
    #   *********
    # 3 *       * 4
    #   *       *
    #   *********
    #       1

    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
    assert_equal [nil, [10, 20], nil, [20, 10]], cutter.connector_locations(0, 0)
    assert_equal [nil, [30, 20], [20, 10], nil], cutter.connector_locations(1, 0)
    assert_equal [[10, 20], nil, nil, [20, 30]], cutter.connector_locations(0, 1)
    assert_equal [[30, 20], nil, [20, 30], nil], cutter.connector_locations(1, 1)
    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 80
    
    assert_equal [nil, [10, 20], nil, [20, 10]], cutter.connector_locations(0, 0)
    assert_equal [nil, [30, 20], [20, 10], [40,10]], cutter.connector_locations(1, 0)
    assert_equal [nil, [50, 20], [40, 10], nil], cutter.connector_locations(2, 0)
    
    assert_equal [[10,20], [10, 40], nil, [20, 30]], cutter.connector_locations(0, 1)
    assert_equal [[30,20], [30, 40], [20, 30], [40,30]], cutter.connector_locations(1, 1)
    assert_equal [[50,20], [50, 40], [40, 30], nil], cutter.connector_locations(2, 1)
    
    assert_equal [[10,40], [10, 60], nil, [20, 50]], cutter.connector_locations(0, 2)
    assert_equal [[30,40], [30, 60], [20, 50], [40,50]], cutter.connector_locations(1, 2)    
    assert_equal [[50,40], [50, 60], [40, 50], nil], cutter.connector_locations(2, 2)
    
    assert_equal [[10,60], nil, nil, [20,70]], cutter.connector_locations(0, 3)    
    assert_equal [[30,60], nil, [20,70], [40,70]], cutter.connector_locations(1, 3)
    assert_equal [[50,60], nil, [40,70], nil], cutter.connector_locations(2, 3)    
  end
  
  def test_should_get_points_for_the_rectangle_for_the_transperant_piece_giving_a_place
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 60
    
      #       2
      #   *********
      # 3 *       * 4
      #   *       *
      #   *********
      #       1

    assert_equal [nil, [0, 20, 22, 22], nil, [20, 0, 22, 22]], cutter.rectangle_locations(0, 0)
    assert_equal [nil, [22, 20, 40, 22], [20, 0, 18, 22], [40, 0, 42, 22]], cutter.rectangle_locations(1, 0)
    assert_equal [nil, [40, 22, 60, 24], [38, 0, 36, 24]], cutter.rectangle_locations(2, 0)

    assert_equal [ [0, 42, 44, 44], [42, 0, 24, 24], []], cutter.rectangle_locations(0, 0)
    assert_equal [[16, 22, 44, 24], [16, 0, 18, 24], [42, 0, 44, 24]], cutter.rectangle_locations(1, 0)
    assert_equal [[36, 22, 60, 24], [38, 0, 36, 24]], cutter.rectangle_locations(2, 0)


    
    
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