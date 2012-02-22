module PuzzleGenerator
  class Cutter
    CONNECTOR_TOP_PATTERN = [-1, -1 ,1]
    CONNECTOR_RIGHT_PATTERN = [1, 1, -1]
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

    def piece_points(row_x , row_y, include_connector_size = true)
      # the pieces should overlap so we have a way to make the connector
      start_point_x = row_x * piece_size
      start_point_y = row_y * piece_size
      # if by adding the connector buffer we have gone passed the edge of the image
      # go back to the edge of the image.
      piece_width = piece_size 
      piece_height = piece_size
      if include_connector_size
        piece_width += connector_size if start_point_x + piece_width < image_width
        piece_height += connector_size if start_point_y + piece_height < image_height
      end

      [start_point_x, start_point_y, piece_width, piece_height]
    end
    
    def connector_locations(row_x, row_y)
      points = []
      pp = piece_points(row_x, row_y, false)
      height = pp.pop
      width = pp.pop
      mid = piece_size / 2
      
      points << [pp[0] + mid, pp[1]]
      points << [pp[0] + mid, pp[1] + height]
      points << [pp[0], pp[1] + mid]
      points << [pp[0] + width, pp[1] + mid]
      points[0][1] += connector_radius unless border_point?(points[0])
      points[1][1] += connector_radius unless border_point?(points[1])
      points[2][0] += connector_radius unless border_point?(points[2])
      points[3][0] += connector_radius unless border_point?(points[3])
      points.delete_if {|points| border_point?(points) }
      points
    end
    
    def border_point?(points)
      points.include?(0) || points[0] == image_width || points[1] == image_height
    end
    
    def connector_types(row_x, row_y)
      # Pattern based connectors
      # Top and right connector can be anything. We determine this based on a pattern.
      top = connector_top(row_x, row_y)
      right = connector_right(row_x, row_y)

      # Fitter connectors
      # left and bottom connectors need are fitters. Meaning they might fit to was on top and to the right.
      # I determine this by shifting to that piece and looking at either the top or right piece and getting the
      # opposite of that piece. If that piece is at the border we return nil.
      left = row_x - 1 >= 0 ? (connector_right(row_x -1, row_y) * -1) : nil
      bottom = row_y - 1 >= 0 ? (connector_top(row_x, row_y - 1) * -1) : nil
      
      puts "BOTTOM #{bottom}, top #{top},left #{left},right #{right}"

      [bottom, top , left, right]
    end
    
    def connector_top(row_x, row_y)
      # -1 because it's a count vs location starting at 0.
      return nil if vertical_pieces - 1 == row_y
      CONNECTOR_TOP_PATTERN[row_x % CONNECTOR_TOP_PATTERN.size]
    end
    
    def connector_right(row_x, row_y)
      # -1 because it's a count vs location starting at 0.
      return nil if horizontal_pieces - 1 == row_x
      CONNECTOR_RIGHT_PATTERN[row_x % CONNECTOR_RIGHT_PATTERN.size]
    end
  end
end