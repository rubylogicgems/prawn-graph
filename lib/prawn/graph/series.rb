require "securerandom"

module Prawn
  module Graph

    # A Prawn::Graph::Series represents a series of data which are to be plotted
    # on a chart.
    #
    class Series
      attr_accessor :values, :options, :uuid

      DEFAULT_OPTIONS = {
        title:        nil,
        type:         :bar,
        mark_average: false,
        mark_minimum: false,
        mark_maximum: false,
        yaxis_min:    0,
        yaxis_max:    0
      }

      def initialize(values = [], options = {})
        @values   = values
        @options  = OpenStruct.new(DEFAULT_OPTIONS.merge(options))
        @uuid = SecureRandom.uuid
      end

      # @return [String] The value of +options.title+.
      #
      def title
        options.title
      end

      # @return [Symbol] The value of +options.type+.
      #
      def type
        options.type
      end

      # @param value [Object] a value to be added to the series. Must be of the same kind as other +values+.
      # @return [Array] The modified +values+ object.
      #
      def <<(value)
        @values << value
      end

      # @return [Numeric] The smallest value stored in the +values+ of this Series.
      #
      def min
        options.yaxis_min || @values.min || 0
      end

      # @return [Numeric] The largest value stored in the +values+ of this Series.
      #
      def max
        options.yaxis_max || @values.max || 0
      end

      # @return [Numeric] The average value stored in the +values+ of this Series.
      #
      def avg
        if size > 0
          @values.inject(:+) / size
        else
          0
        end
      end

      # @return [Numeric] The size of the +values+ stored in this Series.
      #
      def size
        @values.size
      end

      def mark_average?
        options.mark_average == true
      end

      def mark_minimum?
        options.mark_minimum == true
      end

      def mark_maximum?
        options.mark_maximum == true
      end
    end
  end
end
