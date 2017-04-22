require 'spec_helper'

RSpec.describe PayjpMock::Ext::Integer do
  using described_class

  it { expect(7.days).to eq 604800 }
end
