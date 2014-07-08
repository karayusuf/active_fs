module ActiveFS
  module Model
    class Attributes

      def initialize(attributes)
        @attributes = { 'id' => nil }

        Array(attributes).each do |attr|
          @attributes[attr.to_s] = nil
        end
      end

      def to_h
        @attributes
      end

      def update(attributes)
        attributes.each { |attr, value| self[attr] = value }
      end

      def [](attr)
        @attributes[attr.to_s]
      end

      def []=(attr, value)
        @attributes[attr.to_s] = value
      end

      def keys
        @attributes.keys
      end

      def values
        @attributes.values
      end

    end
  end
end

