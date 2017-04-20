require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Customer do
  specify do
    customer = described_class.new
    attrs    = customer.attributes

    expect(attrs[:id]).to start_with 'cus_'
    expect(attrs[:object]).to eq 'customer'

    expect(attrs[:cards]).to be_a Hash
    expect(attrs[:cards][:object]).to eq 'list'
    expect(attrs[:cards][:url]).to eq "/v1/customers/#{attrs[:id]}/cards"

    expect(attrs[:subscriptions]).to be_a Hash
    expect(attrs[:subscriptions][:object]).to eq 'list'
    expect(attrs[:subscriptions][:url]).to eq "/v1/customers/#{attrs[:id]}/subscriptions"

    expect(customer.body).to be_a String
  end
end
