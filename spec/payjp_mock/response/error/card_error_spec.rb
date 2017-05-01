require 'spec_helper'

RSpec.describe PayjpMock::Response::Error::CardError do
  specify do
    error = described_class.new(code: 'invalid_cvc', param: 'card[cvc]')
    attrs = error.attributes

    expect(attrs[:status]).to eq 402
    expect(attrs[:type]).to eq 'card_error'
    expect(attrs[:code]).to eq 'invalid_cvc'
    expect(attrs[:param]).to eq 'card[cvc]'

    expect(JSON.parse(error.body)).to have_key 'error'
    expect(error.status).to eq 402
    expect(error.exception).to be_nil
  end
end
