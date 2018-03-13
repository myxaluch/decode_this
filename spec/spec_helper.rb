# frozen_string_literal: true
require_relative 'simplecov_helper'
require 'bundler/setup'
require 'logger'
require 'decode_this'

DecodeThis.env = :test

def encode(payload, config_path = nil)
  config = YAML.load(File.open(config_path))[DecodeThis.env] || DecodeThis.config
  private_key = OpenSSL::PKey::RSA.new(File.read(config['key_path']))
  "#{config['authorization_scheme']} " + JWT.encode(payload, private_key, config['algorithm'])
end
