require "RMagick"

module PuzzleGenerator
  class ImageHandler
    attr_accessor :folder_location

    def source(file_location)
      return @source_file unless @source_file.nil?
      @file_location = file_location
      @source_file = Magick::Image.read(file_location).first
      @cutter = Cutter.new
      @cutter.piece_size = @source_file.columns * 0.1
      @cutter.image_width = @source_file.columns
      @cutter.image_height = @source_file.rows
      @source_file = @source_file.crop(*(@cutter.piece_fitting_diamentions + [true]))
      @source_file
    end
        
    def single_piece(row_x, row_y)
      
      # get the source image and crop it to the appropriate size.
      bg = @source_file.crop(*(@cutter.piece_points(row_x, row_y) + [true]))
      
      # This will be the final image output
      img = Magick::Image.new(bg.columns,bg.rows)
      img.compression = Magick::LZWCompression
      
      # draw the image that is suppose to be invisible.
      gc = Magick::Draw.new
      gc.stroke_antialias(false)
      gc.stroke_width(0)

      # first start with black box.
      gc.fill('#000000')
      gc.rectangle(0,0,bg.columns, bg.rows)
      
      # draw rectangles around the edges of the images aka "buffers"
      # that will later be made transperant
      gc.fill('#09f700')
      @cutter.rectangle_locations(row_x, row_y).each do |a_rectangle|
        gc.rectangle(*a_rectangle) unless a_rectangle.nil?
      end
      
      # draw the up to 4 connectors
      connector_types = @cutter.connector_types(row_x, row_y)
      @cutter.connector_locations(row_x, row_y).each_with_index do |connector, index|
        unless connector.nil?
          gc.fill('#09f700') if connector_types[index] == -1
          gc.fill('#000000') if connector_types[index] == 1
          points = connector
          points << (connector[0] + @cutter.connector_radius)
          points << connector[1]
          gc.circle(*points)
        end
      end
      
      # draw the image and composite the background image (bg) and set the transparency.
      # Creating a cookie cutter affect.
      gc.draw(img)
      img = img.matte_replace((bg.columns / 2).to_i,(bg.rows / 2).to_i)
      img = bg.composite(img, Magick::CenterGravity, Magick::OverCompositeOp)
      img = img.transparent('#09f700')
      img.write(folder_location + @file_location.sub(/\..*$/, "-#{row_x}_#{row_y}.gif"))
    end
    
    def all_piece
      @cutter.vertical_pieces.times do |y_axis|
        @cutter.horizontal_pieces.times do |x_axis|
          single_piece(x_axis, y_axis)
        end
      end
    end
  end
end
