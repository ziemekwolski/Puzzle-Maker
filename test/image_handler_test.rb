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
    img_handle.source("simple_sample.jpg")
    img_handle.single_piece(0,0)
    assert_equal File.size("./puzzle_created/made/simple_sample-0_0.gif"), File.size("./puzzle_created/correct/simple_sample-0_0.gif")
  end

  def test_should_create_a_whole_puzzle_using_a_square_image
    img_handle = ImageHandler.new
    img_handle.folder_location = "./puzzle_created/made/"
    img_handle.source("simple_sample.jpg")
    img_handle.all_piece
    10.times do |x|
      10.times do |y|
        assert_equal File.size("./puzzle_created/made/simple_sample-#{x}_#{y}.gif"), File.size("./puzzle_created/correct/simple_sample-#{x}_#{y}.gif")
      end
    end
    `cd ./puzzle_created/made/ && rm *`
  end
  
  def test_should_create_a_whole_puzzle_using_regular_photo
    img_handle = ImageHandler.new
    img_handle.folder_location = "./puzzle_created/made/"
    img_handle.source("regular_photo.jpg")
    img_handle.all_piece
    8.times do |x|
      4.times do |y|
        assert_equal File.size("./puzzle_created/made/regular_photo-#{x}_#{y}.gif"), File.size("./puzzle_created/correct/regular_photo-#{x}_#{y}.gif")
      end
    end
    `cd ./puzzle_created/made/ && rm *`
  end
  
end