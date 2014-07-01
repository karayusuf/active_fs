require 'fileutils'
require 'csv'

module ActiveFS
  module Model
    module FileManager
      BUCKET_SIZE = 10_000

      def self.create(directory, attributes)
        attributes[:id] = AutoIncrementer.increment(directory)
        update(directory, attributes[:id], attributes)
      end

      def self.update(directory, id, attributes)
        FileUtils.mkdir_p(bucket(directory, id))
        File.write(path(directory, id), JSON(attributes.to_h))
      end

      def self.find(model, directory, id)
        data = JSON.parse(File.read(path(directory, id)))
        model.new(data)
      end

      def self.exists?(directory, id)
        id && !id.to_s.empty? && File.exists?(path(directory, id))
      end

      private

      def self.bucket(directory, id)
        "#{directory}/#{(id.to_i / BUCKET_SIZE)}"
      end

      def self.path(directory, id)
        "#{bucket(directory, id)}/#{id}"
      end

    end
  end
end

