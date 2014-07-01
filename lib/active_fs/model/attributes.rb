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
        validate!(attr)
        @attributes[attr.to_s]
      end

      def []=(attr, value)
        validate!(attr)
        @attributes[attr.to_s] = value
      end

      def keys
        @attributes.keys
      end

      def values
        @attributes.values
      end

      private

      def validate!(attr)
        keys.include?(attr.to_s) or fail UnknownAttribute.new(attr, keys)
      end

      class UnknownAttribute < StandardError
        def initialize(attribute, known_attributes)
          @attribute = attribute
          @known_attributes = known_attributes
        end

        def message
          message = "Unknown attribute: #{@attribute}\n"
          message << "Expected one of: #{@known_attributes.join(', ')}"
        end
      end

    end
  end
end

