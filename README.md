# PayjpMock

A stubbing library for PAY.JP

This library creates PAY.JP API stubs and generates dummy responses.

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

### Signature

```
payjp_stub(resource, operation, params: {}, source: {}, error: nil, response: nil)
```

See also: [lib/payjp_mock/webmock_wrapper.rb](https://github.com/kirikiriyamama/payjp_mock/blob/master/lib/payjp_mock/webmock_wrapper.rb)

### Example

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
  payjp_stub(:charges, :create, params: { amount: 3500, card: 'tok_xxxxx', currency: 'jpy' })
  Payjp::Charge.create(amount: 3500, card: 'tok_xxxxx', currency: 'jpy')

  # Stubbing nested resource operations such as customer's card list retrival
  payjp_stub(:customer, :retrieve)
  customer = Payjp::Customer.retrieve('cus_xxxxx')

  payjp_stub({ customer: :cards }, :all)
  customer.cards.all

  # Specifying response attributes
  payjp_stub(:charge, :retrieve, source: { captured: false, captured_at: nil })
  charge = Payjp::Charge.retrieve('ch_xxxxx')

  charge.captured    #=> false
  charge.captured_at #=> nil

  # Stubbing error responses
  payjp_stub({ customer: :cards }, :create, error: :invalid_request_error)
  customer.cards.create #=> Raises a Payjp::InvalidRequestError

  # Specifying error response attributes
  payjp_stub(:charges, :create, response: payjp_card_error(code: 'processing_error'))
  Payjp::Charge.create #=> Raises a Payjp::CardError with code processing_error
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

