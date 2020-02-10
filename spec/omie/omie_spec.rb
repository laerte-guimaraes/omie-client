# frozen_string_literal: true

require 'spec_helper'
require 'omie'

RSpec.describe Omie do
  it "has a version number" do
    expect(Omie::VERSION).not_to be nil
  end
end
