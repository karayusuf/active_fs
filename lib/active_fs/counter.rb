require 'fileutils'

module ActiveFS
  module Counter

    def self.increment(directory, file)
      begin
        update(directory, file, 1)
      rescue Errno::ENOENT
        FileUtils.mkdir_p(directory)
        update(directory, file, 1)
      end
    end

    private

    def self.update(directory, file, difference)
      File.open("#{directory}/#{file}", File::RDWR|File::CREAT) do |file|
        file.flock(File::LOCK_EX)
        id = file.gets.to_i + difference

        file.rewind
        file.write(id)
        id
      end
    end

  end
end

