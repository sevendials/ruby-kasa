# Kasa

Connect directly to TP Link Kasa devices on your local network
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kasa'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kasa

## Usage
To scan local network and turn on first device:
```
require 'kasa'

kasa = Kasa.new
kasa.devices.first.on
```

Local network device is detected but can be optionally overridden:
```
require 'kasa'

kasa = Kasa.new(discover_interface_override: 'eth1')
```

To connect to known host and adjust brightness:
```
require 'kasa'

device = Kasa::Factory.new('192.168.1.55')
device.brightness=50
```

To get device summary:
```
require 'kasa'

kasa = Kasa.new
kasa.summary
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sevendials/ruby-kasa.
