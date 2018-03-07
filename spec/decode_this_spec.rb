# frozen_string_literal: true
require 'spec_helper'

RSpec.describe DecodeThis do
  let(:config_path) { File.expand_path('spec/fixtures/config.yml') }
  let(:payload) { { field: 'foobar' } }
  let(:token) { encode(payload) }

  subject(:decoded_token) { described_class.new(token, config_file: config_path, env: :test).decode }

  it 'decodes given token correctly' do
    payload.keys.each do |key|
      expect(decoded_token[key.to_s]).to eq(payload[key])
    end
  end
end
