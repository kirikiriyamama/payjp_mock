require 'spec_helper'

RSpec.describe PayjpMock::Ext::Hash do
  using described_class

  describe '#symbolize_keys' do
    specify do
      expect(
        { 'k1' => 'v1', 'k2' => 'v2' }.symbolize_keys
      ).to eq({ k1: 'v1', k2: 'v2' })
    end
  end

  describe '#except' do
    specify do
      expect(
        { k1: :v1, k2: :v2 }.except(:k1, :k3)
      ).to eq({ k2: :v2 })
    end
  end

  describe '#deep_transform_values' do
    specify do
      expect(
        { k1: 1, k2: 2, k3: { k4: 4, k5: { k6: 6 } } }.deep_transform_values(&:to_s)
      ).to eq({ k1: '1', k2: '2', k3: { k4: '4', k5: { k6: '6' } } })
    end
  end
end
