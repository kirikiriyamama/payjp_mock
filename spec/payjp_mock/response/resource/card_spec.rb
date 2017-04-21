require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Card do
  specify do
    card  = described_class.new
    attrs = card.attributes

    expect(attrs[:id]).to start_with 'car_'
    expect(attrs[:object]).to eq 'card'
    expect(attrs[:customer]).to start_with 'cus_'

    expect(card.body).to be_a String
    expect(card.status).to eq 200
    expect(card.exception).to be_nil
  end
end
