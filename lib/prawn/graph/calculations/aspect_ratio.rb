module Prawn
  module Graph
    module Calculations

      # This AspectRatio class (and most of the other calculations stuff) has been taken from the prawn-svg
      # project (https://github.com/mogest/prawn-svg) which is by Roger Nesbitt and made available under the
      # MIT Licence. 
      #
      class AspectRatio
        attr_reader :align, :defer
        attr_reader :width, :height, :x, :y

        def initialize(value, container_dimensions, object_dimensions)
          values = (value || "xMidYMid meet").strip.split(/\s+/)
          @x = @y = 0

          if values.first == "defer"
            @defer = true
            values.shift
          end

          @align, @meet_or_slice = values

          @w_container, @h_container = container_dimensions
          @w_object,    @h_object    = object_dimensions

          @container_ratio = @w_container / @h_container.to_f
          @object_ratio    = @w_object / @h_object.to_f

          calculate_dimensions!
        end

        def calculate_dimensions!
          if @align == "none"
            @width  = @w_container
            @height = @h_container
          else
            matches = @align.to_s.strip.match(/\Ax(Min|Mid|Max)Y(Min|Mid|Max)\z/i) || [nil, "Mid", "Mid"]

            if (@container_ratio > @object_ratio) == slice?
              @width, @height = [@w_container, @w_container / @object_ratio]
              @y = case matches[2].downcase
                   when "min" then 0
                   when "mid" then (@h_container - @w_container/@object_ratio)/2
                   when "max" then @h_container - @w_container/@object_ratio
                   end
            else
              @width, @height = [@h_container * @object_ratio, @h_container]
              @x = case matches[1].downcase
                   when "min" then 0
                   when "mid" then (@w_container - @h_container*@object_ratio)/2
                   when "max" then @w_container - @h_container*@object_ratio
                   end
            end
          end
        end

        def slice?
          @meet_or_slice == "slice"
        end

        def meet?
          @meet_or_slice != "slice"
        end

        def inspect
          "[AspectRatio: #{@width},#{@height} offset #{@x},#{@y}]"
        end
      end

    end
  end
end