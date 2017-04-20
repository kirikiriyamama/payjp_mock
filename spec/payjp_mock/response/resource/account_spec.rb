require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Account do
  specify do
    account = described_class.new
    attrs   = account.attributes

    expect(attrs[:id]).to start_with 'acct_'
    expect(attrs[:object]).to eq 'account'

    expect(attrs[:merchant]).to be_a Hash
    expect(attrs[:merchant][:id]).to start_with 'acct_mch_'
    expect(attrs[:merchant][:object]).to eq 'merchant'

    expect(account.body).to be_a String
  end
end
