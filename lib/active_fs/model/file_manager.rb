require 'fileutils'
require 'csv'

require 'active_fs/counter'

module ActiveFS
  module Model
    module FileManager
      BUCKET_SIZE = 10_000
      AUTO_INCREMENT = 'AUTO_INCREMENT'

      def self.create(directory, attributes)
        attributes[:id] = Counter.increment(directory, AUTO_INCREMENT)
        update(directory, attributes[:id], attributes)
      end

      def self.update(directory, id, attributes)
        begin
          File.write(path(directory, id), JSON(attributes.to_h))
        rescue Errno::ENOENT
          FileUtils.mkdir_p(bucket(directory, id))
          File.write(path(directory, id), JSON(attributes.to_h))
        end
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

