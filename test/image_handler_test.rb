require 'test/unit'
require 'puzzle_generator/cutter'
require 'puzzle_generator/image_handler'

class ImageHandlerTest < Test::Unit::TestCase
  include PuzzleGenerator
  
  def test_should_read_source_images
    img_handle = ImageHandler.new
    assert_equal Magick::Image.read("./sample.jpg"), img_handle.source("./sample.jpg")
  end
  
  
end