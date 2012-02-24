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

    # because these points will be applied to individual cut up images, 
    # I don't need the points as they relate to the full image. 
    # I only need the points as they relate to the cut image, but
    # you need to account for the overlap aka buffer for the connectors.
    # remember connector radius and overlap is 2px not 4px.
    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 40
    cutter.image_height = 40
    
               # [10,0], [10, 20], [0, 10], [20, 10]
    assert_equal [nil, [10, 20], nil, [20, 10]], cutter.connector_locations(0, 0)
    assert_equal [nil, [12, 20], [2, 10], nil], cutter.connector_locations(1, 0)
    assert_equal [[10, 2], nil, nil, [20, 12]], cutter.connector_locations(0, 1)
    assert_equal [[12, 2], nil, [2, 12], nil], cutter.connector_locations(1, 1)
    
    cutter = Cutter.new
    cutter.piece_size = 20
    cutter.image_width = 60
    cutter.image_height = 60
    
               # [10,0], [10, 20], [0, 10], [20, 10]
    assert_equal [nil, [10, 20], nil, [20, 10]], cutter.connector_locations(0, 0)
    assert_equal [nil, [12, 20], [2, 10], [22,10]], cutter.connector_locations(1, 0)
    assert_equal [nil, [12, 20], [2, 10], nil], cutter.connector_locations(2, 0)
    
    assert_equal [[10,2], [10, 22], nil, [20, 12]], cutter.connector_locations(0, 1)
    assert_equal [[12,2], [12, 22], [2, 12], [22, 12]], cutter.connector_locations(1, 1)
    assert_equal [[12,2], [12, 22], [2, 12], nil], cutter.connector_locations(2, 1)
    
    assert_equal [[10,2], nil, nil, [20, 12]], cutter.connector_locations(0, 2)
    assert_equal [[12,2], nil, [2, 12], [22, 12]], cutter.connector_locations(1, 2)    
    assert_equal [[12,2], nil, [2, 12], nil], cutter.connector_locations(2, 2)
  end
  
  def test_should_get_points_for_the_rectangle_for_the_transperant_piece_giving_a_place
    # Again, I don't need the rectangles that apply to the image as a whole, only
    # the rectangles that relate to each individual piece. 
    
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
    assert_equal [nil, [0, 20, 24, 22], [0, 0, 2, 22], [22, 0, 24, 22]], cutter.rectangle_locations(1, 0)
    assert_equal [nil, [0, 20, 22, 22], [0, 0, 2, 22], nil], cutter.rectangle_locations(2, 0)

    # here I have to account for the buffer space at the bottom as well as the top so 
    # all the points are raised.
    assert_equal [[0, 0, 22, 2], [0, 22, 22, 24], nil, [20, 0, 22, 24]], cutter.rectangle_locations(0, 1)
    # image is now 24 pixel wide cause, it's in the center of the image, not bound by anything. -- we need the buffer
    assert_equal [[0,0, 24, 2], [0, 22, 24, 24], [0, 0, 2, 24], [22, 0, 24, 24]], cutter.rectangle_locations(1, 1)
    assert_equal [[0,0, 22, 2], [0, 22, 22, 24], [0, 0, 2, 24], nil], cutter.rectangle_locations(2, 1)

    assert_equal [[0,0, 22, 2], nil, nil, [20, 0, 22, 22]], cutter.rectangle_locations(0, 2)
    assert_equal [[0,0, 24, 2], nil, [0, 0, 2, 22], [22, 0, 24, 22]], cutter.rectangle_locations(1, 2)
    assert_equal [[0,0, 22, 2], nil, [0, 0, 2, 22], nil], cutter.rectangle_locations(2, 2)
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