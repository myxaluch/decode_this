# frozen_string_literal: true
require 'decode_this/safe_decoding'
require 'openssl'
require 'jwt'
require 'huyettings'

module DecodeThis
  class Decoder
    attr_reader :header_value, :config_file, :env, :logger

    def initialize(header_value, config_file:, env:, logger: nil)
      @header_value = header_value
      @config_file = config_file
      @env = env
      @logger = logger
    end

    def call
      safe_decode { JWT.decode(token, public_key, true, algorithm: algorithm).first }
    end

    private

    def config
      @config ||= Huyettings.new(config_file, env)
    end

    def algorithm
      config.algorithm
    end

    def token
      return unless header_value

      token = header_value.match(/^#{config.authorization_scheme} (.+)/)
      token[1] if token
    end

    def public_key
      private_key.public_key
    end

    def safe_decode(&block)
      DecodeThis::SafeDecoding.call(logger, &block)
    end

    def private_key
      OpenSSL::PKey::RSA.new(pem)
    end

    def pem
      keys_absolute_path = File.expand_path(config.key_path)

      if !File.readable?(keys_absolute_path)
        raise DecodeThis::KeyFileNotFoundError.new("Cannot found file in #{config.key_path}")
      end

      File.read(config.key_path)
    end
  end
end
