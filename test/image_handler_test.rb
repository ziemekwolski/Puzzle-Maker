require 'test/unit'
require 'puzzle_generator/cutter'
require 'puzzle_generator/image_handler'

class ImageHandlerTest < Test::Unit::TestCase
  include PuzzleGenerator
  
  # def test_should_read_source_images
  #   img_handle = ImageHandler.new
  #   assert_equal Magick::Image.read("./sample.jpg").first, img_handle.source("./sample.jpg")
  # end
  # 
  # def test_should_resize_image_if_the_piece_dont_exactly_fit_into_the_image_size
  #   img_handle = ImageHandler.new
  #   assert_equal Magick::Image.read("./sample.jpg").first, img_handle.source("./sample.jpg")
  #   
  # end
  
  def test_should_create_a_single_piece_based
    img_handle = ImageHandler.new
    img_handle.folder_location = "./puzzle_created/made/"
    img_handle.source("simple_sample.JPG")
    img_handle.single_piece(0,0)
    
  end

  def test_should_create_a_single_piece_based
    img_handle = ImageHandler.new
    img_handle.folder_location = "./puzzle_created/made/"
    img_handle.source("simple_sample.JPG")
    img_handle.all_piece
    
  end
  
  
end