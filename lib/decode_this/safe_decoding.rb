# frozen_string_literal: true
module DecodeThis
  BaseError = Class.new(RuntimeError)
  ConfigFileNotFoundError = Class.new(BaseError)
  KeyFileNotFoundError = Class.new(BaseError)
  DecodeError = Class.new(BaseError)

  class SafeDecoding
    def self.call(logger, &block)
      block.call

    rescue JWT::ExpiredSignature => err
      handle_and_log_error(
        DecodeThis::DecodeError,
        "Expired token #{err.class} - #{err.message}",
        logger
      )
    rescue JWT::VerificationError => err
      handle_and_log_error(
        DecodeThis::DecodeError,
        "Can't verify token #{err.class} - #{err.message}",
        logger
      )
    rescue JWT::DecodeError => err
      handle_and_log_error(
        DecodeThis::DecodeError,
        "Can't decode token #{err.class} - #{err.message}",
        logger
      )
    rescue DecodeThis::KeyFileNotFoundError => err
      handle_and_log_error(
        DecodeThis::KeyFileNotFoundError,
        err.message,
        logger
      )
    end

    def self.handle_and_log_error(raising_error, message, logger = nil)
      logger.warn(message) if logger

      raise raising_error.new(message)
    end
  end
end
