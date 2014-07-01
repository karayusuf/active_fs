require 'csv'
require 'json'
require 'fileutils'

require 'active_fs/auto_incrementer'
require 'active_fs/model/attributes'
require 'active_fs/model/file_manager'

module ActiveFS
  module Model

    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = Attributes.new(fields)
      @attributes.update(attributes)
    end

    def id
      @attributes[:id]
    end

    def save
      new_record? ? create : update
    end

    def directory
      self.class.directory
    end

    def fields
      self.class.fields
    end

    private

    def create
      FileManager.create(directory, attributes)
    end

    def update
      FileManager.update(directory, id, attributes)
    end

    def new_record?
      !FileManager.exists?(directory, id)
    end

    def self.included(model)
      model.extend(ClassMethods)
    end

    module ClassMethods
      def directory(directory = nil)
        @directory ||= directory
      end

      def fields
        @fields ||= [:id]
      end

      def attribute(attr)
        fields.push(attr)
        define_method(attr) { attributes[attr] }
        define_method("#{attr}=") { |value| attributes[attr] = value }
      end

      def attributes(*attrs)
        attrs.each { |attr| attribute(attr) }
      end

      def find(id)
        FileManager.find(self, directory, id)
      end
    end
  end
end

