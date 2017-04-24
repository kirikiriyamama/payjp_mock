require 'spec_helper'

RSpec.describe PayjpMock::Response::Resource::Charge do
  specify do
    charge = described_class.new(card: { exp_year: 2017, exp_month: 4 }, expiry_days: 30)
    attrs  = charge.attributes

    expect(attrs[:id]).to start_with 'ch_'
    expect(attrs[:object]).to eq 'charge'
    expect(attrs[:expiry_days]).to be_nil
    expect(attrs[:expired_at]).to be_an Integer

    expect(attrs[:card]).to be_a Hash
    expect(attrs[:card][:object]).to eq 'card'
    expect(attrs[:card][:exp_year]).to eq 2017
    expect(attrs[:card][:exp_month]).to eq 4

    expect(charge.body).to be_a String
    expect(charge.status).to eq 200
    expect(charge.exception).to be_nil
  end

  context 'when `capture` is set to true' do
    specify do
      charge = described_class.new(capture: true)
      attrs  = charge.attributes

      expect(attrs[:capture]).to be_nil
      expect(attrs[:captured]).to eq true
      expect(attrs[:captured_at]).to be_an Integer
    end
  end

  context 'when `capture` is set to false' do
    specify do
      charge = described_class.new(capture: false)
      attrs  = charge.attributes

      expect(attrs[:capture]).to be_nil
      expect(attrs[:captured]).to eq false
      expect(attrs[:captured_at]).to be_nil
    end
  end
end
