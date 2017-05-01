require 'spec_helper'

RSpec.describe PayjpMock::Response::Error::InvalidRequestError do
  specify do
    error = described_class.new(code: 'missing_param')
    attrs = error.attributes

    expect(attrs[:status]).to eq 400
    expect(attrs[:type]).to eq 'client_error'
    expect(attrs[:code]).to eq 'missing_param'

    expect(JSON.parse(error.body)).to have_key 'error'
    expect(error.status).to eq 400
    expect(error.exception).to be_nil
  end
end
