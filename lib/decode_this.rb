# frozen_string_literal: true
require 'decode_this/version'
require 'decode_this/safe_decoding'
require 'yaml'
require 'jwt'

module DecodeThis
  def self.decode(header_value)
    token = token_from_header(header_value)

    safe_decode { JWT.decode(token, public_key, true, algorithm: config['algorithm']).first }
  end

  def self.config
    raise ConfigFileNotFoundError.new("Cannot found configuration file in #{@config_path}") unless @config_path

    @config ||= YAML.load(File.open(@config_path))[@env]
  end

  def self.config_path=(config_path)
    @config_path = File.expand_path(config_path)
  end

  def self.config_path
    @config_path
  end

  def self.logger
    @logger
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.env=(env)
    @env = env.to_s
  end

  def self.env
    @env
  end

  private

  def self.safe_decode(&block)
    SafeDecoding.call(logger, &block)
  end

  def self.token_from_header(header_value)
    return unless header_value

    token = header_value.match(/^#{config['authorization_scheme']} (.+)/)
    token[1] if token
  end

  def self.public_key
    OpenSSL::PKey::RSA.new(pem).public_key
  end

  def self.pem
    keys_absolute_path = File.expand_path(config['key_path'])

    if !File.readable?(keys_absolute_path)
      raise DecodeThis::KeyFileNotFoundError.new("Cannot found file in #{config['key_path']}")
    end

    File.read(config['key_path'])
  end
end
