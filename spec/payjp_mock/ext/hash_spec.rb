require 'spec_helper'

RSpec.describe PayjpMock::Ext::Hash do
  using described_class

  it { expect({ 'k1' => 'v1', 'k2' => 'v2' }.symbolize_keys).to eq({ k1: 'v1', k2: 'v2' }) }
end
