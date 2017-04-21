require 'spec_helper'

RSpec.describe PayjpMock::Response::List do
  specify do
    list  = described_class.new('/items')
    attrs = list.attributes

    expect(attrs[:object]).to eq 'list'
    expect(attrs[:url]).to eq '/v1/items'
    expect(attrs[:count]).to eq 0
    expect(attrs[:data]).to be_empty

    expect(list.body).to be_a String
    expect(list.status).to eq 200
    expect(list.exception).to be_nil
  end

  specify do
    list  = described_class.new('/items') { [[:k1, :v1], [:k2, :v2]] }
    attrs = list.to_h

    expect(attrs[:count]).to eq 3
    expect(attrs[:data].count).to eq 3
    expect(attrs[:data][0]).to be_a Hash
  end

  specify do
    list  = described_class.new('/items', count: 1) { [[:k1, :v1], [:k2, :v2]] }
    attrs = list.to_h

    expect(attrs[:count]).to eq 1
    expect(attrs[:data].count).to eq 1
  end
end
