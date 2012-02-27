module PuzzleGenerator
  class Cutter
    CONNECTOR_TOP_PATTERN = [-1, -1 ,1]
    CONNECTOR_RIGHT_PATTERN = [1, 1, -1]
    attr_accessor :piece_size, :image_width, :image_height
    
    def horizontal_pieces
      (image_width / piece_size).to_i
    end

    def vertical_pieces
      (image_height / piece_size).to_i
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
      end_point_x = start_point_x + piece_width
      end_point_y = start_point_y + piece_height
      
      #translating number of pieces to positions
      horizontal_position = horizontal_pieces - 1
      vertical_position = vertical_pieces - 1
      
      if include_connector_size
        start_point_x -= connector_radius if row_x > 0
        start_point_y -= connector_radius if row_y > 0

        # if the piece are not on the edges, they are bigger by the radius of the connector.
        piece_width += connector_radius if row_x < horizontal_position
        piece_height += connector_radius if row_y < vertical_position
        
        piece_width += connector_radius if row_x > 0 
        piece_height += connector_radius if row_y > 0
      end

      [start_point_x, start_point_y, piece_width, piece_height]
    end
    
    def get_connector_locations_matrix
      matrix = []
      vertical_pieces.times do |y_axis|
        horizontal_pieces.times do |x_axis|
          matrix << connector_locations(x_axis, y_axis)
        end
      end
      matrix
    end
    
    def connector_locations(row_x, row_y)
      points = []
      mid = piece_size / 2
      width = piece_size
      height = piece_size
      cr = connector_radius
      vertical_position = vertical_pieces - 1
      horizontal_position = horizontal_pieces - 1
      
      points << (row_y == 0 ? nil : [mid, 0])
      points << (row_y == vertical_position ? nil : [mid, height])
      points << (row_x == 0 ? nil : [0, mid])
      points << (row_x == horizontal_position ? nil : [width, mid])
      
      if row_y > 0
        points[0][1] += cr unless points[0].nil?
        points[1][1] += cr unless points[1].nil?
        points[2][1] += cr unless points[2].nil?
        points[3][1] += cr unless points[3].nil?
      end
      
      if row_x > 0 
        #use loop
        points[0][0] += cr unless points[0].nil?
        points[1][0] += cr unless points[1].nil?
        points[2][0] += cr unless points[2].nil?
        points[3][0] += cr unless points[3].nil?
      end
      points
    end
    
    def get_rectangle_matrix
      matrix = []
      vertical_pieces.times do |y_axis|
        horizontal_pieces.times do |x_axis|
          matrix << rectangle_locations(x_axis, y_axis)
        end
      end
      matrix
    end
    
    def rectangle_locations(row_x, row_y)
      points = []
      width = piece_size
      height = piece_size
      cr = connector_radius
      vertical_position = vertical_pieces - 1
      horizontal_position = horizontal_pieces - 1
      
      
      points << (row_y == 0 ? nil : [0,0, width, cr])
      points << (row_y == vertical_position ? nil : [0,height, width, height + cr])
      points << (row_x == 0 ? nil : [0,0, cr, height])
      points << (row_x == horizontal_position ? nil : [width, 0, width + cr, height])
      
      if row_x > 0
        
        points[0][2] += cr unless points[0].nil?
        points[1][2] += cr unless points[1].nil?
        
        points[3][0] += cr unless points[3].nil?
        points[3][2] += cr unless points[3].nil?
      end
      
      if row_x <  horizontal_position
        points[0][2] += cr unless points[0].nil?
        points[1][2] += cr unless points[1].nil?
      end
      
      if row_y > 0
        points[1][1] += cr unless points[1].nil?
        points[1][3] += cr unless points[1].nil?
        
        points[2][3] += cr unless points[2].nil?
        
        points[3][3] += cr unless points[3].nil?
      end
      
      if row_y < vertical_position
        points[2][3] += cr unless points[2].nil?
        points[3][3] += cr unless points[3].nil?
      end
      
      points
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
    
    def piece_fitting_diamentions
      horizontal = horizontal_pieces * piece_size
      vertical = vertical_pieces * piece_size
      self.image_width = horizontal
      self.image_height = vertical
      [0, 0,horizontal ,vertical ]
    end
  end
end