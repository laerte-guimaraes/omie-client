# frozen_string_literal: true

module Omie
  describe BaseResource do
    class TestClass < BaseResource
      attr_accessor :foo, :bar
    end

    let(:entry) { Omie::TestClass.new(bar: 1, foo: 2) }

    it 'receives multiple attributes in initializer' do
      expect(entry.foo).to eq(2)
      expect(entry.bar).to eq(1)
    end

    it 'updates attributes based on hash' do
      entry.update_attributes(bar: 4)

      expect(entry.foo).to eq(2)
      expect(entry.bar).to eq(4)
    end
  end
end
