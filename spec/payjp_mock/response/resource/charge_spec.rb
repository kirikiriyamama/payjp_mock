require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Charge do
  specify do
    charge = described_class.new
    attrs  = charge.attributes

    expect(attrs[:id]).to start_with 'ch_'
    expect(attrs[:object]).to eq 'charge'

    expect(attrs[:card]).to be_a Hash
    expect(attrs[:card][:object]).to eq 'card'

    expect(charge.body).to be_a String
  end
end
