# PayjpMock

A stubbing library for PAY.JP

This library creates PAY.JP API stubs and generates dummy responses. This is under development, so any incompatible change might happen.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payjp_mock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install payjp_mock

## Usage

Here's an example with RSpec:

```ruby
# spec/spec_helper.rb
require 'payjp_mock'

RSpec.configure do |config|
  config.include PayjpMock::WebMockWrapper
end

# Your spec file
require 'payjp'

specify do
  # Stubbing charge creation
  payjp_stub(:charges, :create)
  Payjp::Charge.create(amount: 3500, card: 'tok_xxxxx', currency: 'jpy')

  # Stubbing nested resources operation such as customer's card list retrival
  payjp_stub(:customer, :retrival)
  customer = Payjp::Customer.retrieve('cus_xxxxx')

  payjp_stub({ customer: :cards }, :all)
  customer.cards.all

  # Stubbing error responses
  payjp_stub({ customer: :cards }, :create, error: :invalid_request_error)
  customer.cards.create #=> Raises a Payjp::InvalidRequestError

  # snip
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kirikiriyamama/payjp_mock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Thanks

[webpay/webpay-mock](https://github.com/webpay/webpay-mock): As an implementation reference

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

