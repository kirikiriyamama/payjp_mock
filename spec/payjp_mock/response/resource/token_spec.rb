require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Token do
  specify do
    token = described_class.new
    attrs = token.attributes

    expect(attrs[:id]).to start_with 'tok'
    expect(attrs[:object]).to eq 'token'

    expect(attrs[:card]).to be_a Hash
    expect(attrs[:card][:object]).to eq 'card'

    expect(token.body).to be_a String
    expect(token.status).to eq 200
    expect(token.exception).to be_nil
  end
end
