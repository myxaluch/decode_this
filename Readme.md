# DecodeThis

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
  algorightm: 'RS256'
  path: 'paht/to/keys'
```

```ruby
token = DecodeThis.call(token, config_file: '/path/to/config.yml', env: :my_env)
token['field1']
token['field2']
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/myxaluch/decode_this.
