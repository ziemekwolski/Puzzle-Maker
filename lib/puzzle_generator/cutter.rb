module PuzzleGenerator
  class Cutter
    attr_accessor :piece_size, :image_width, :image_height
    
    def horizontal_pieces
      image_width / piece_size
    end

    def vertical_pieces
      image_height / piece_size
    end
    
    def connector_size
      return @connector_size unless @connector_size.nil?
      @connector_size = piece_size * 0.2
    end
    
    def connector_radius
      return connector_size / 2
    end
    
    def get_piece_matrix
      matrix = []
      vertical_pieces.times do |y_axis|
        horizontal_pieces.times do |x_axis|
          matrix << piece_points(x_axis, y_axis)
        end
      end
      matrix
    end

    def piece_points(row_x , row_y)
      # the peices should overlap so we have a way to make the connector
      points = []
      points << row_x * piece_size
      points << row_y * piece_size
      # if by adding the connector buffer we have gone passed the edge of the image
      # go back to the edge of the image.
      end_point_x = (row_x * piece_size) + piece_size + connector_size
      end_point_x = image_width if end_point_x > image_width
      
      end_point_y = (row_y * piece_size) + piece_size + connector_size
      end_point_y = image_height if end_point_y > image_height
      
      points << end_point_x
      points << end_point_y
      points
    end
    
    def connector_locations(row_x, row_y)
      points = []
      
      
      2.times do |y_axis|
        2.times do |x_axis|
          puts x_axis, y_axis
          # point_x = row_x * (piece_size / 2)
          # point_y = row_y * (piece_size / 2)
          
        end
      end
      
    end

  end
end