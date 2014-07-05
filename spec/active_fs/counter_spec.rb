require 'spec_helper'
require 'active_fs/counter'

module ActiveFS
  describe Counter do
    let(:threads)  { [] }
    let(:filename) { 'counter' }

    describe ".increment" do
      it "returns the new count" do
        count = Counter.increment(EXAMPLE_FOLDER, filename)
        expect(count).to eql 1

        count = Counter.increment(EXAMPLE_FOLDER, filename)
        expect(count).to eql 2
      end

      it "prevents the file from being written to at the same time" do
        50.times do
          threads << Thread.new do
            Counter.increment(EXAMPLE_FOLDER, filename)
          end
        end

        threads.map(&:join)
        expect(File.read("#{EXAMPLE_FOLDER}/counter")).to eql '50'
      end
    end

  end
end

