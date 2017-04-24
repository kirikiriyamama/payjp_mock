require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Subscription do
  specify do
    subscription = described_class.new
    attrs        = subscription.attributes

    expect(attrs[:id]).to start_with 'sub_'
    expect(attrs[:object]).to eq 'subscription'

    expect(attrs[:plan]).to be_a Hash
    expect(attrs[:plan][:object]).to eq 'plan'

    expect(subscription.body).to be_a String
    expect(subscription.status).to eq 200
    expect(subscription.exception).to be_nil
  end
end
