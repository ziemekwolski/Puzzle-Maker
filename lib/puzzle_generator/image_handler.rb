require "RMagick"

module PuzzleGenerator
  class ImageHandler
    attr_accessor :folder_location

    def source(file_location)
      return @source_file unless @source_file.nil?
      @file_location = file_location
      @source_file = Magick::Image.read(file_location).first
      @cutter = Cutter.new
      @cutter.piece_size = @source_file.columns * 0.2
      @cutter.image_width = @source_file.columns
      @cutter.image_height = @source_file.rows
      @source_file
    end
        
    def single_piece(row_x, row_y)
      
      bg = @source_file.crop(*(@cutter.piece_points(row_x, row_y) + [true]))
      
      puts bg.columns,bg.rows
      img = Magick::Image.new(bg.columns,bg.rows)
      img.compression = Magick::LZWCompression
      img.transparent_color = '#09f700'
      
      gc = Magick::Draw.new
      gc.stroke_width(0)
      # #09f700
      # transparent
      gc.fill('#09f700')
      @cutter.rectangle_locations(row_x, row_y).each do |a_rectangle|
        gc.rectangle(*a_rectangle) unless a_rectangle.nil?
      end
      
      # draw the 4 connectors
      connector_types = @cutter.connector_types(row_x, row_y)
      puts connector_types.inspect
      @cutter.connector_locations(row_x, row_y).each_with_index do |connector, index|
        unless connector.nil?
          puts index.inspect
          gc.fill('#09f700') if connector_types[index] == -1
          gc.fill('white') if connector_types[index] == 1
          points = connector
          points << (connector[0] + @cutter.connector_radius)
          points << connector[1]
          gc.circle(*points)
        end
      end
      
      gc.draw(img)
      img = img.matte_replace((bg.columns / 2).to_i,(bg.rows / 2).to_i)
      img = bg.composite(img, Magick::CenterGravity, Magick::OverCompositeOp)
      img.transparent('#09f700').write(folder_location + @file_location.sub(/\..*$/, "-#{row_x}_#{row_y}.gif"))
      
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
