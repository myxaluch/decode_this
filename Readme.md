# DecodeThis

[![Build Status](https://travis-ci.org/myxaluch/decode_this.svg?branch=master)](https://travis-ci.org/myxaluch/decode_this)

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
  path: 'paht/to/keys'
```

```ruby
payload = {
  'field1' => 'foo',
  'field2' => 'bar'
}
jwt_token = JWT.encode(payload, private_token, true, algorithm: algorithm)
...
decoded_token = DecodeThis.call(jwt_token, config_file: '/path/to/config.yml', env: :my_env)
token['field1'] = 'foo'
token['field2'] = 'bar'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/myxaluch/decode_this.
