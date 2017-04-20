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
        expect(Payjp::Charge.create).to be_a Payjp::Charge
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:charge, :retrieve)
        expect(Payjp::Charge.retrieve('ch_xxxxx')).to be_a Payjp::Charge
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:charge, :retrieve)
        charge = Payjp::Charge.retrieve('ch_xxxxx')

        payjp_stub(:charge, :save)
        expect(charge.save).to be_a Payjp::Charge
      end
    end

    describe 'refund' do
      specify do
        payjp_stub(:charge, :retrieve)
        charge = Payjp::Charge.retrieve('ch_xxxxx')

        payjp_stub(:charge, :refund)
        response = charge.refund

        expect(response).to be_a Payjp::Charge
        expect(response.refunded).to be_truthy
      end
    end

    describe 'reauth' do
      specify do
        skip "payjp-ruby hasn't supported re-authentication yet"
      end
    end

    describe 'capture' do
      specify do
        payjp_stub(:charge, :retrieve)
        charge = Payjp::Charge.retrieve('ch_xxxxx')

        payjp_stub(:charge, :capture)
        response = charge.capture

        expect(response).to be_a Payjp::Charge
        expect(response.captured).to be_truthy
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:charges, :all)
        response = Payjp::Charge.all

        expect(response).to be_a Payjp::ListObject
        expect(response.data.first).to be_a Payjp::Charge
      end
    end
  end

  describe 'customers' do
    describe 'create' do
      specify do
        payjp_stub(:customers, :create)
        expect(Payjp::Customer.create).to be_a Payjp::Customer
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:customer, :retrieve)
        expect(Payjp::Customer.retrieve('cus_xxxxx')).to be_a Payjp::Customer
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:customer, :retrieve)
        customer = Payjp::Customer.retrieve('cus_xxxxx')

        payjp_stub(:customers, :save)
        expect(customer.save).to be_a Payjp::Customer
      end
    end

    describe 'delete' do
      specify do
        payjp_stub(:customer, :retrieve)
        customer = Payjp::Customer.retrieve('cus_xxxxx')

        payjp_stub(:customer, :delete)
        response = customer.delete

        expect(response).to be_a Payjp::Customer
        expect(response.deleted).to be_truthy
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:customers, :all)
        response = Payjp::Customer.all

        expect(response).to be_a Payjp::ListObject
        expect(response.data.first).to be_a Payjp::Customer
      end
    end

    describe 'cards' do
      before { payjp_stub(:customer, :retrieve) }
      let!(:customer) { Payjp::Customer.retrieve('cus_xxxxx') }

      describe 'create' do
        specify do
          payjp_stub({ customer: :cards }, :create)
          expect(customer.cards.create).to be_a Payjp::Card
        end
      end

      describe 'retrieve' do
        specify do
          payjp_stub({ customer: :card }, :retrieve)
          expect(customer.cards.retrieve('car_xxxxx')).to be_a Payjp::Card
        end
      end

      describe 'save' do
        specify do
          payjp_stub({ customer: :card }, :retrieve)
          card = customer.cards.retrieve('car_xxxxx')

          payjp_stub({ customer: :card }, :save)
          expect(card.save).to be_a Payjp::Card
        end
      end

      describe 'delete' do
        specify do
          payjp_stub({ customer: :card }, :retrieve)
          card = customer.cards.retrieve('car_xxxxx')

          payjp_stub({ customer: :card }, :delete)
          response = card.delete

          expect(response).to be_a Payjp::Card
          expect(response.deleted).to be_truthy
        end
      end

      describe 'all' do
        specify do
          payjp_stub({ customer: :cards }, :all)
          response = customer.cards.all

          expect(response).to be_a Payjp::ListObject
          expect(response.data.first).to be_a Payjp::Card
        end
      end
    end
  end

  describe 'plans' do
    describe 'create' do
      specify do
        payjp_stub(:plans, :create)
        expect(Payjp::Plan.create).to be_a Payjp::Plan
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:plan, :retrieve)
        expect(Payjp::Plan.retrieve('pln_xxxxx')).to be_a Payjp::Plan
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:plan, :retrieve)
        plan = Payjp::Plan.retrieve('pln_xxxxx')

        payjp_stub(:plan, :save)
        expect(plan.save).to be_a Payjp::Plan
      end
    end

    describe 'delete' do
      specify do
        payjp_stub(:plan, :retrieve)
        plan = Payjp::Plan.retrieve('pln_xxxxx')

        payjp_stub(:plan, :delete)
        response = plan.delete

        expect(response).to be_a Payjp::Plan
        expect(response.deleted).to be_truthy
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:plans, :all)
        response = Payjp::Plan.all

        expect(response).to be_a Payjp::ListObject
        expect(response.data.first).to be_a Payjp::Plan
      end
    end
  end

  describe 'subscriptions' do
    describe 'create' do
      specify do
        payjp_stub(:subscriptions, :create)
        expect(Payjp::Subscription.create).to be_a Payjp::Subscription
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:subscription, :retrieve)
        expect(Payjp::Subscription.retrieve('sub_xxxxx')).to be_a Payjp::Subscription
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :save)
        expect(subscription.save).to be_a Payjp::Subscription
      end
    end

    describe 'pause' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :pause)
        response = subscription.pause

        expect(response).to be_a Payjp::Subscription
        expect(response.status).to eq 'paused'
        expect(response.paused_at).to be_an Integer
      end
    end

    describe 'resume' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :resume)
        response = subscription.resume

        expect(response).to be_a Payjp::Subscription
        expect(response.status).to eq 'active'
        expect(response.resumed_at).to be_an Integer
      end
    end

    describe 'cancel' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :cancel)
        response = subscription.cancel

        expect(response).to be_a Payjp::Subscription
        expect(response.status).to eq 'canceled'
        expect(response.canceled_at).to be_an Integer
      end
    end

    describe 'delete' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :delete)
        response = subscription.delete

        expect(response).to be_a Payjp::Subscription
        expect(response.deleted).to be_truthy
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:subscriptions, :all)
        response = Payjp::Subscription.all

        expect(response).to be_a Payjp::ListObject
        expect(response.data.first).to be_a Payjp::Subscription
      end
    end
  end

  describe 'tokens' do
    describe 'create' do
      specify do
        payjp_stub('tokens', :create)
        expect(Payjp::Token.create).to be_a Payjp::Token
      end
    end

    describe 'retrieve' do
      specify do
        payjp_stub(:token, 'retrieve')
        expect(Payjp::Token.retrieve('tok_xxxxx')).to be_a Payjp::Token
      end
    end
  end

  describe 'transfers' do
    describe 'retrieve' do
      specify do
        payjp_stub(:transfer, :retrieve)
        expect(Payjp::Transfer.retrieve('tr_xxxxx')).to be_a Payjp::Transfer
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:transfers, :all)
        response = Payjp::Transfer.all

        expect(response).to be_a Payjp::ListObject
        expect(response.data.first).to be_a Payjp::Transfer
      end
    end

    describe 'chrages' do
      describe 'all' do
        specify do
          payjp_stub(:transfer, :retrieve)
          transfer = Payjp::Transfer.retrieve('tr_xxxxx')

          payjp_stub({ transfer: :charges }, :all)
          response = transfer.charges.all

          expect(response).to be_a Payjp::ListObject
          expect(response.data.first).to be_a Payjp::Charge
        end
      end
    end
  end

  describe 'events' do
    describe 'retrieve' do
      specify do
        payjp_stub(:event, :retrieve)
        expect(Payjp::Event.retrieve('evnt_xxxxx')).to be_a Payjp::Event
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:events, :all)
        response = Payjp::Event.all

        expect(response).to be_a Payjp::ListObject
        expect(response.data.first).to be_a Payjp::Event
      end
    end
  end

  describe 'accounts' do
    describe 'retrieve' do
      specify do
        payjp_stub(:account, :retrieve)
        expect(Payjp::Account.retrieve).to be_a Payjp::Account
      end
    end
  end
end
