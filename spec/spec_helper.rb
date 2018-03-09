# frozen_string_literal: true
require_relative 'simplecov_helper'
require 'bundler/setup'
require 'logger'
require 'decode_this'

def encode(payload)
  config = Huyettings.new(File.expand_path('spec/fixtures/config.yml'), :test)
  private_key = OpenSSL::PKey::RSA.new(File.read(config.key_path))
  "#{config.authorization_scheme} " + JWT.encode(payload, private_key, config.algorithm)
end
