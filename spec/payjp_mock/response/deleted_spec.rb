require 'spec_helper'

RSpec.describe PayjpMock::Response::Deleted do
  specify do
    id = 'cus_xxxxx'

    deleted = described_class.new(id)
    attrs   = deleted.attributes

    expect(attrs[:id]).to eq id
    expect(attrs[:deleted]).to be_truthy

    expect(deleted.body).to be_a String
  end
end
