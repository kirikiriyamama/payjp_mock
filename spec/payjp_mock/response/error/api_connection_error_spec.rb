require 'spec_helper'

RSpec.describe PayjpMock::Response::Error::ApiConnectionError do
  specify do
    error = described_class.new

    expect(error.attributes).to be_nil
    expect(error.body).to be_nil
    expect(error.status).to be_nil
    expect(error.exception).to eq SocketError
  end
end
