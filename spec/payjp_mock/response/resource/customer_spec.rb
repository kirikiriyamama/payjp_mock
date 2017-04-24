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
    expect(customer.status).to eq 200
    expect(customer.exception).to be_nil
  end

  context 'when `card` is set to a token id' do
    specify do
      customer = described_class.new(card: 'tok_xxxxx')

      cards = customer.attributes[:cards]
      expect(cards[:count]).to eq 1
    end
  end

  context 'when `card` is set to a card object' do
    specify do
      customer = described_class.new(card: { exp_year: 2017, exp_month: 4 })

      cards = customer.attributes[:cards]
      expect(cards[:count]).to eq 1
      expect(cards[:data][0][:exp_year]).to eq 2017
      expect(cards[:data][0][:exp_month]).to eq 4
    end
  end

  context 'when `default_card` is specified' do
    specify do
      customer = described_class.new(default_card: 'car_xxxxx')

      cards = customer.attributes[:cards]
      expect(cards[:count]).to eq 1
      expect(cards[:data][0][:id]).to eq 'car_xxxxx'
    end
  end
end
