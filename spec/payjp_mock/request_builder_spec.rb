require 'spec_helper'

RSpec.describe PayjpMock::RequestBuilder do
  specify do
    builder = described_class.new(:xxxxx, :create, nil)
    expect { builder.build }.to raise_error PayjpMock::RequestBuilder::UnknownResource
  end

  specify do
    builder = described_class.new(:charges, :xxxxx, :card_error)
    expect { builder.build }.to raise_error PayjpMock::RequestBuilder::UnknownOperation
  end
end
