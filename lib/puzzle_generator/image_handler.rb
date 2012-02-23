require "RMagick"
require "File"

module PuzzleGenerator
  class ImageHandler
    attr_accessor :folder_location

    def source(file_location)
      return @source_file unless @source_file.nil?
      @file_location = file_location
      @source_file = Magick::Image.read(file_location).first
    end
    
    def crop
      @cutter = Cutter.new
      @cutter.piece_size = @source_file.columns * 0.2

      # we crop the image for now, to make sure that everything fits
      # remove the part of the image that will not fit because of the piece being to big.
      new_width = (@source_file.columns / @cutter.piece_size).to_i * @cutter.piece_size 
      @source_file = @source_file.crop(0,0, new_width, @source_file.columns)

      @cutter.image_width = @source_file.columns
      @cutter.image_height = @source_file.rows
      @source_file
    end
    
    def single_piece(row_x, row_y)
      bg = @source_file.crop(*@cutter.piece_points(row_x, row_y))
      
      img = Magick::Image.new(bg.columns,bg.rows)
      img.compression = Magick::LZWCompression
      
      # 
      gc = Magick::Draw.new
      gc.stroke_width(0)
      gc.fill('#09f700')
      gc.roundrectangle(0, 0, 199, 199, 0, 0)
      
      
      puts @file_location.inspect
      img.write(folder_location + @file_location.sub(/\./, "-#{row_x}_#{row_y}."))
      
    end
  end
end
