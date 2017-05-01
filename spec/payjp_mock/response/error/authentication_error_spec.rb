require 'spec_helper'

RSpec.describe PayjpMock::Response::Error::AuthenticationError do
  specify do
    error = described_class.new(message: 'message')
    attrs = error.attributes

    expect(attrs[:status]).to eq 401
    expect(attrs[:type]).to eq 'auth_error'
    expect(attrs[:message]).to eq 'message'

    expect(JSON.parse(error.body)).to have_key 'error'
    expect(error.status).to eq 401
    expect(error.exception).to be_nil
  end
end
