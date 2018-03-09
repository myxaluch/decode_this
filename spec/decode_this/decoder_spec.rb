# frozen_string_literal: true
require 'spec_helper'

RSpec.describe DecodeThis::Decoder do
  let(:config_path) { File.expand_path('spec/fixtures/config.yml') }
  let(:payload) { { field: 'foobar' } }
  let(:header_value) { encode(payload) }
  let(:logger) { Logger.new(STDOUT) }

  subject(:decoded_token) do
    described_class.new(header_value, config_file: config_path, env: :test, logger: logger).call
  end

  it 'decodes given token correctly' do
    payload.keys.each do |key|
      expect(decoded_token[key.to_s]).to eq(payload[key])
    end
  end

  context 'when check correct error raising' do
    context 'when raise error when config file not present' do
      let(:config_path) { 'spec/fixtures/nonexistent_config.yml' }

      it 'raises ConfigFileNotFoundError' do
        expect(logger).to receive(:warn).and_call_original
        expect { decoded_token }.to raise_error { DecodeThis::KeyFileNotFoundError }
      end
    end

    context 'when raise error when token is expired' do
      let(:payload) { { field: 'foobar', exp: -1 } }

      it 'raises DecodeError' do
        expect(logger).to receive(:warn).and_call_original
        expect { decoded_token }.to raise_error { DecodeThis::DecodeError }
      end
    end

    context 'when raise error when try to decode by another key' do
      let(:config_path) { File.expand_path('spec/fixtures/another_config.yml') }

      it 'raises DecodeError' do
        expect(logger).to receive(:warn).and_call_original
        expect { decoded_token }.to raise_error { DecodeThis::DecodeError }
      end
    end
  end
end
