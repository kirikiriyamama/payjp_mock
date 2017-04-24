require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Subscription do
  specify do
    trial_end = Time.local(2017, 4, 24).to_i

    subscription = described_class.new(plan: 'pln_xxxxx', trial_end: trial_end)
    attrs        = subscription.attributes

    expect(attrs[:id]).to start_with 'sub_'
    expect(attrs[:object]).to eq 'subscription'
    expect(attrs[:status]).to eq 'trial'
    expect(attrs[:trial_start]).to be_an Integer
    expect(attrs[:trial_end]).to eq trial_end

    expect(attrs[:plan]).to be_a Hash
    expect(attrs[:plan][:object]).to eq 'plan'
    expect(attrs[:plan][:id]).to eq 'pln_xxxxx'

    expect(subscription.body).to be_a String
    expect(subscription.status).to eq 200
    expect(subscription.exception).to be_nil
  end
end
