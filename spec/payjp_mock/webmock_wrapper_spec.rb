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
        payjp_stub(:charges, :create, params: { amount: 1000 })
        charge = Payjp::Charge.create(amount: 1000)

        expect(charge.amount).to eq 1000
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

        payjp_stub(:charge, :save, params: { description: 'description' })
        charge.description = 'description'

        response = charge.save
        expect(response.description).to eq 'description'
      end
    end

    describe 'refund' do
      specify do
        payjp_stub(:charge, :retrieve)
        charge = Payjp::Charge.retrieve('ch_xxxxx')

        payjp_stub(:charge, :refund)
        response = charge.refund

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
        payjp_stub(:customers, :create, params: { id: 'cus_xxxxx' })
        customer = Payjp::Customer.create(id: 'cus_xxxxx')

        expect(customer.id).to eq 'cus_xxxxx'
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

        payjp_stub(:customers, :save, params: { description: 'description' })
        customer.description  = 'description'

        response = customer.save
        expect(customer.description).to eq 'description'
      end
    end

    describe 'delete' do
      specify do
        payjp_stub(:customer, :retrieve)
        customer = Payjp::Customer.retrieve('cus_xxxxx')

        payjp_stub(:customer, :delete)
        response = customer.delete

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
          payjp_stub({ customer: :cards }, :create, params: { exp_year: 2017, exp_month: 4 })
          card = customer.cards.create(exp_year: 2017, exp_month: 4)

          expect(card.exp_year).to eq 2017
          expect(card.exp_month).to eq 4
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

          payjp_stub({ customer: :card }, :save, params: { exp_year: 2038, exp_month: 1 })
          card.exp_year  = 2038
          card.exp_month = 1

          response = card.save
          expect(card.exp_year).to eq 2038
          expect(card.exp_month).to eq 1
        end
      end

      describe 'delete' do
        specify do
          payjp_stub({ customer: :card }, :retrieve)
          card = customer.cards.retrieve('car_xxxxx')

          payjp_stub({ customer: :card }, :delete)
          response = card.delete

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
        payjp_stub(:plans, :create, params: { amount: 2000, interval: 'year' })
        plan = Payjp::Plan.create(amount: 2000, interval: 'year')

        expect(plan.amount).to eq 2000
        expect(plan.interval).to eq 'year'
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

        payjp_stub(:plan, :save, params: { name: 'name' })
        plan.name = 'name'

        response = plan.save
        expect(response.name).to eq 'name'
      end
    end

    describe 'delete' do
      specify do
        payjp_stub(:plan, :retrieve)
        plan = Payjp::Plan.retrieve('pln_xxxxx')

        payjp_stub(:plan, :delete)
        response = plan.delete

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
        payjp_stub(:subscriptions, :create, params: { prorate: true })
        subscription = Payjp::Subscription.create(prorate: true)

        expect(subscription.prorate).to be_truthy
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

        payjp_stub(:subscription, :save, params: { plan: 'pln_xxxxx' })
        subscription.plan = 'pln_xxxxx'

        response = subscription.save
        expect(response.plan.id).to eq 'pln_xxxxx'
      end
    end

    describe 'pause' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :pause)
        response = subscription.pause

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
        payjp_stub('tokens', :create, params: { card: { exp_year: 2038, exp_month: 1 } })
        token = Payjp::Token.create(card: { exp_year: 2038, exp_month: 1 })

        expect(token.card.exp_year).to eq 2038
        expect(token.card.exp_month).to eq 1
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
        stub = payjp_stub(:account, :retrieve)
        expect(Payjp::Account.retrieve.id).to eq stub[:id]
      end
    end
  end

  describe 'card error' do
    specify do
      payjp_stub(:tokens, :create, error: :card_error)
      expect { Payjp::Token.create }.to raise_error Payjp::CardError
    end
  end

  describe 'invalid request error' do
    specify do
      payjp_stub(:charges, :create, error: :invalid_request_error)
      expect { Payjp::Charge.create }.to raise_error Payjp::InvalidRequestError
    end
  end

  describe 'authentication error' do
    specify do
      payjp_stub(:customer, :retrieve, error: 'authentication_error')
      expect { Payjp::Customer.retrieve('cus_xxxxx') }.to raise_error Payjp::AuthenticationError
    end
  end

  describe 'api connection error' do
    specify do
      payjp_stub(:account, :retrieve, error: 'api_connection_error')
      expect { Payjp::Account.retrieve }.to raise_error Payjp::APIConnectionError
    end
  end

  describe 'api error' do
    specify do
      payjp_stub(:transfer, :retrieve)
      transfer = Payjp::Transfer.retrieve('tr_xxxxx')

      payjp_stub({ transfer: :charges }, :all, error: :api_error)
      expect { transfer.charges.all }.to raise_error Payjp::APIError
    end
  end
end
