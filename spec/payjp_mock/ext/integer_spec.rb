require 'spec_helper'

RSpec.describe IntegerExtension do
  include described_class

  it { expect(7.days).to eq 604800 }
end
