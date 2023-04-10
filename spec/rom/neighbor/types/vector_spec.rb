# frozen_string_literal: true

require 'spec_helper'
require 'pgvector'

RSpec.describe ROM::Neighbor::Types::Vector do
  let(:vector_type) { described_class.new }

  describe 'Vector column' do
    it 'casts a vector to the specified dimensions' do
      input_vector = [1.0, 2.0, 3.0]
      output_vector = vector_type.call(input_vector)
      expect(output_vector).to eq(input_vector)
    end
  end
end
