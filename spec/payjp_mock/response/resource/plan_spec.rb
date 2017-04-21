require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Plan do
  specify do
    plan  = described_class.new
    attrs = plan.attributes

    expect(attrs[:id]).to start_with 'pln_'
    expect(attrs[:object]).to eq 'plan'

    expect(plan.body).to be_a String
    expect(plan.status).to eq 200
    expect(plan.exception).to be_nil
  end
end
