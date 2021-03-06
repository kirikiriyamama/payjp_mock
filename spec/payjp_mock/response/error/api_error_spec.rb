require 'spec_helper'

RSpec.describe PayjpMock::Response::Error::ApiError do
  specify do
    error = described_class.new(code: 'payjp_wrong')
    attrs = error.attributes

    expect(attrs[:status]).to eq 503
    expect(attrs[:type]).to eq 'server_error'
    expect(attrs[:code]).to eq 'payjp_wrong'

    expect(JSON.parse(error.body)).to have_key 'error'
    expect(error.status).to eq 503
    expect(error.exception).to be_nil
  end
end
