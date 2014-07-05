require 'fileutils'

module ActiveFS
  module Counter

    def self.increment(directory, file)
      FileUtils.mkdir_p(directory)
      File.open("#{directory}/#{file}", File::RDWR|File::CREAT) do |file|
        file.flock(File::LOCK_EX)
        id = file.gets.to_i + 1

        file.rewind
        file.write(id)
        id
      end
    end

  end
end

