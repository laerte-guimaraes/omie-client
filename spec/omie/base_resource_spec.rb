# frozen_string_literal: true

require 'spec_helper'
require 'omie'

module Omie
  describe BaseResource do
    class TestClass < BaseResource
      attr_accessor :foo, :bar
    end

    class HighLevelTestClass < BaseResource
      INTERNAL_MODELS = {
        test_class: Omie::TestClass
      }.freeze

      attr_accessor :test_class, :another_attribute
    end

    describe 'regular resource' do
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

    describe 'resource with internal model' do
      let(:resource) do
        Omie::HighLevelTestClass.new(
          test_class: { bar: 10, foo: 20 }, another_attribute: 'XPTO'
        )
      end

      it 'initializes the related internal model' do
        expect(resource.another_attribute).to eq('XPTO')

        test_instance = resource.test_class
        expect(test_instance).to be_a(Omie::TestClass)
        expect(test_instance.foo).to eq(20)
        expect(test_instance.bar).to eq(10)
      end
    end
  end
end
