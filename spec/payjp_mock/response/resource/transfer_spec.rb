require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Transfer do
  specify do
    transfer = described_class.new
    attrs    = transfer.attributes

    expect(attrs[:id]).to start_with 'tr_'
    expect(attrs[:object]).to eq 'transfer'
    expect(attrs[:scheduled_date]).to match /\d{2}-\d{2}-\d{2}/

    expect(attrs[:charges]).to be_a Hash
    expect(attrs[:charges][:object]).to eq 'list'
    expect(attrs[:charges][:url]).to eq "/v1/transfers/#{attrs[:id]}/charges"

    charge = attrs[:charges][:data][0]
    expect(charge[:object]).to eq 'charge'
    expect(charge[:card]).to be_a Hash
    expect(charge[:card][:object]).to eq 'card'

    expect(transfer.body).to be_a String
  end
end
