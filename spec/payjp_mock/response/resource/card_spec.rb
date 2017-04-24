require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Card do
  specify do
    card  = described_class.new(number: '0000000000001234', cvc: '123')
    attrs = card.attributes

    expect(attrs[:id]).to start_with 'car_'
    expect(attrs[:object]).to eq 'card'
    expect(attrs[:customer]).to start_with 'cus_'
    expect(attrs[:number]).to be_nil
    expect(attrs[:last4]).to eq '1234'
    expect(attrs[:cvc]).to be_nil

    expect(card.body).to be_a String
    expect(card.status).to eq 200
    expect(card.exception).to be_nil
  end
end
