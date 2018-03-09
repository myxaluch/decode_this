# DecodeThis

[![Build Status](https://travis-ci.org/myxaluch/decode_this.svg?branch=master)](https://travis-ci.org/myxaluch/decode_this)
[![Test Coverage](https://api.codeclimate.com/v1/badges/182d13aea55106ba87a4/test_coverage)](https://codeclimate.com/github/myxaluch/decode_this)

Simple decoder JWT token by given key

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decode_this'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install decode_this

## Usage

Configuration file scheme:
```
test:
  algorithm: 'RS256'
  authorization_scheme: 'Bearer'
  key_path: 'paht/to/keys'
```

```ruby
payload = {
  'field1' => 'foo',
  'field2' => 'bar'
}
jwt_token = JWT.encode(payload, private_key, true, algorithm: algorithm)
...
header_value = request.env['HTTP_AUTHENTICATION'] // "Bearer fgjsgkjsfslfjg.."
decoded_token = DecodeThis::Decoder.call(
  header_value,
  config_file: '/path/to/config.yml',
  env: :my_env,
  logger: logger
)

token['field1'] = 'foo'
token['field2'] = 'bar'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/myxaluch/decode_this.
