# frozen_string_literal: true
require 'decode_this/version'
require 'huyettings'
require 'openssl'
require 'jwt'

class DecodeThis
  ConfigFileNotFoundError = Class.new(RuntimeError)
  DecodeError = Class.new(RuntimeError)

  attr_reader :token, :config_file, :env, :logger

  def initialize(token, config_file:, env:, logger: nil)
    @token = token
    @config_file = config_file
    @env = env
    @logger = logger
  end

  def call
    JWT.decode(token, public_key, true, algorithm: algorithm).first

  rescue JWT::ExpiredSignature => err
    logger.warn("Expired JWT token #{err.class} - #{err.message}")
    raise DecodeError
  rescue JWT::VerificationError => err
    logger.warn("Can't verify JWT token #{err.class} - #{err.message}")
    raise DecodeError
  rescue JWT::DecodeError => err
    logger.warn("Can't decode JWT token '#{jwt_token}' #{err.class} - #{err.message}")
    raise DecodeError
  end

  private

  def jwt_config
    @jwt_config ||= Huyettings.new(config_file, env)
  end

  def algorithm
    jwt_config.algorithm
  end

  def public_key
    private_key.public_key
  end

  def private_key
    OpenSSL::PKey::RSA.new(pem)
  end

  def pem
    keys_absolute_path = File.expand_path(jwt_config.path)

    raise KeyFileNotFoundError.new("Cannot found file in #{jwt_config.path}") unless File.readable?(keys_absolute_path)
    File.read(jwt_config.path)
  end
end
