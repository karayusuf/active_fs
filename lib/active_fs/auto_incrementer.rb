require 'fileutils'

module ActiveFS
  module AutoIncrementer
    FILE = 'AUTO_INCREMENT'

    def self.increment(directory)
      file = "#{directory}/#{FILE}"

      FileUtils.mkdir_p(directory)
      FileUtils.touch(file)

      id = File.read(file).to_i + 1
      File.write(file, id)
      id
    end

  end
end

