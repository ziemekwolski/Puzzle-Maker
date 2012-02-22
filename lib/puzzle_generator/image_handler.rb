require "RMagick"

module PuzzleGenerator
  class ImageHandler
    def source(file_location)
      return @source_file unless @source_file.nil?
      @source_file = Magick::Image.read(file_location)
    end
    
  end
end
