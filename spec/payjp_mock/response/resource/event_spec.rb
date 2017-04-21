require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Event do
  specify do
    event = described_class.new
    attrs = event.attributes

    expect(attrs[:id]).to start_with 'evnt_'
    expect(attrs[:object]).to eq 'event'
    expect(attrs[:data]).to be_a Hash

    expect(event.body).to be_a String
    expect(event.status).to eq 200
    expect(event.exception).to be_nil
  end
end
