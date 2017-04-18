require 'spec_helper'
require 'payjp'
require 'webmock/rspec'

RSpec.describe PayjpMock::WebMockWrapper do
  include described_class

  before do
    Payjp.api_key = 'sk_test_xxxxx'
  end

  describe 'charges' do
    describe 'create' do
      specify do
        payjp_stub(:charges, :create)
        expect { Payjp::Charge.create }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:charge, :retrieve)
        expect { Payjp::Charge.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'save' do
      xspecify do
      end
    end

    describe 'refund' do
      xspecify do
      end
    end

    describe 'reauth' do
      xspecify do
      end
    end

    describe 'capture' do
      xspecify do
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:charges, :all)
        expect { Payjp::Charge.all }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end

  describe 'customers' do
    describe 'create' do
      specify do
        payjp_stub(:customer, :create)
        expect { Payjp::Customer.create }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:customers, :retrieve, id: 'cus_xxxxx')
        expect { Payjp::Customer.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'save' do
      xspecify do
      end
    end

    describe 'delete' do
      xspecify do
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:customers, :all)
        expect { Payjp::Customer.all }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'cards' do
      describe 'create' do
        xspecify do
        end
      end

      describe 'retrieve' do
        xspecify do
        end
      end

      describe 'save' do
        xspecify do
        end
      end

      describe 'delete' do
        xspecify do
        end
      end

      describe 'all' do
        xspecify do
        end
      end
    end
  end

  describe 'plans' do
    describe 'create' do
      specify do
        payjp_stub(:plans, :create)
        expect { Payjp::Plan.create }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:plans, :retrieve, id: 'pln_xxxxx')
        expect { Payjp::Plan.retrieve('pln_xxxxx') }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'save' do
      xspecify do
      end
    end

    describe 'delete' do
      xspecify do
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:plan, :all)
        expect { Payjp::Plan.all }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end

  describe 'subscriptions' do
    describe 'create' do
      specify do
        payjp_stub(:subscription, :create)
        expect { Payjp::Subscription.create }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:subscriptions, :retrieve, 'id' => 'sub_xxxxx')
        expect { Payjp::Subscription.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'save' do
      xspecify do
      end
    end

    describe 'pause' do
      xspecify do
      end
    end

    describe 'resume' do
      xspecify do
      end
    end

    describe 'cancel' do
      xspecify do
      end
    end

    describe 'delete' do
      xspecify do
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:subscriptions, :all, params: { limit: 3 })
        expect { Payjp::Subscription.all }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end

  describe 'tokens' do
    describe 'create' do
      specify do
        payjp_stub('tokens', :create)
        expect { Payjp::Token.create }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:token, :retrieve, params: { 'id' => 'tk_xxxxx' })
        expect { Payjp::Token.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end

  describe 'transfers' do
    describe 'retrieve' do
      specify do
        payjp_stub(:transfers, 'retrieve')
        expect { Payjp::Transfer.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:transfers, :all)
        expect { Payjp::Transfer.all }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'chrages' do
      describe 'all' do
        xspecify do
        end
      end
    end
  end

  describe 'events' do
    describe 'retrieve' do
      specify do
        payjp_stub(:event, :retrieve, 'params' => { 'id' => 'evnt_xxxxx' })
        expect { Payjp::Event.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:events, :all)
        expect { Payjp::Event.all }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end

  describe 'accounts' do
    describe 'retrieve' do
      specify do
        payjp_stub(:account, :retrieve)
        expect { Payjp::Account.retrieve }.to_not raise_error(WebMock::NetConnectNotAllowedError)
      end
    end
  end
end
