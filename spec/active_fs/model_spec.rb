require 'active_fs/model'
require 'spec_helper'

module ActiveFS
  describe Model do

    class Foo
      include ActiveFS::Model

      directory "#{EXAMPLE_FOLDER}/foo"
      attributes :bar, :baz
    end

    describe "#directory" do
      it "stores the directory" do
        foo = Foo.new
        expect(foo.directory).to eql "#{EXAMPLE_FOLDER}/foo"
      end
    end

    describe "#attributes" do
      it "stores the attributes in the order they are defined" do
        model = Foo.new
        expect(model.attributes.keys).to eql ['id', 'bar', 'baz']
      end

      it "provides an accessor for each attribute" do
        model = Foo.new

        model.bar = 'hello'
        expect(model.bar).to eql 'hello'

        model.baz = 'world'
        expect(model.baz).to eql 'world'
      end
    end

    describe "#save" do
      context "when the model doesn't exist" do
        let(:model) { Foo.new }

        it "generates an id" do
          model.save
          expect(model.id).to eql 1
        end

        it "overrides provided ids" do
          model = Foo.new(id: 42)
          model.save

          auto_increment = File.read("#{model.directory}/AUTO_INCREMENT")

          expect(auto_increment).to eql "1"
          expect(model.id).to eql 1
        end

        it "stores the auto increment" do
          model.save
          auto_increment = File.read("#{model.directory}/AUTO_INCREMENT")

          expect(auto_increment).to eql "1"
        end

        it "stores the values of the attributes" do
          model.bar = 'happy'
          model.baz = 'joe'
          model.save

          saved_model = Foo.find(model.id)
          expect(saved_model.bar).to eql 'happy'
          expect(saved_model.baz).to eql 'joe'
        end
      end

      context "when the model already exists" do
        let(:model) { Foo.new }
        before { model.save }

        it "maintains its id" do
          foo = Foo.find(1)
          foo.save

          expect(foo.id).to eql 1
        end

        it "does not update the auto increment" do
          foo = Foo.find(1)
          foo.save

          auto_increment = File.read("#{foo.directory}/AUTO_INCREMENT")

          expect(auto_increment).to eql "1"
        end

        it "saves the new values" do
          model.baz = 'hello'
          model.save

          first_update = Foo.find(model.id)
          expect(first_update.baz).to eql 'hello'

          first_update.baz = 'world'
          first_update.save

          second_update = Foo.find(model.id)
          expect(second_update.baz).to eql 'world'
        end

        it "benchmark" do
          pending
          require 'benchmark'
          require 'pry'

          bm = Benchmark.bm do |x|
            x.report(:save) do
              100_000.times { |x| Foo.new.save }
            end

            x.report(:find) do
              100_000.times { |x| Foo.find(x + 1) }
            end
          end
        end
      end
    end
  end
end

