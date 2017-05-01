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
        payjp_stub(:charge, :retrieve, source: { description: 'description' })
        charge = Payjp::Charge.retrieve('ch_xxxxx')

        expect(charge.description).to eq 'description'
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:charge, :retrieve)
        charge = Payjp::Charge.retrieve('ch_xxxxx')

        payjp_stub(:charge, :save, params: { description: 'description' }, source: { amount: 1000 })
        charge.description = 'description'

        response = charge.save

        expect(response.description).to eq 'description'
        expect(response.amount).to eq 1000
      end
    end

    describe 'refund' do
      let!(:charge) do
        payjp_stub(:charge, :retrieve)
        Payjp::Charge.retrieve('ch_xxxxx')
      end

      context 'when parameter `amount` is specified' do
        specify do
          payjp_stub(:charge, :refund, params: { amount: 1000 }, source: { amount: 2000 })
          response = charge.refund(amount: 1000)

          expect(response.amount).to eq 2000
          expect(response.amount_refunded).to eq 1000
          expect(response.refunded).to be_truthy
        end
      end

      context "when parameter `amount` isn't specified" do
        specify do
          payjp_stub(:charge, :refund, params: { refund_reason: 'reason' }, source: { amount: 1000 })
          response = charge.refund(refund_reason: 'reason')

          expect(response.amount).to eq 1000
          expect(response.amount_refunded).to eq 1000
          expect(response.refunded).to be_truthy
          expect(response.refund_reason).to eq 'reason'
        end
      end
    end

    describe 'reauth' do
      specify do
        skip "payjp-ruby hasn't supported re-authentication yet"
      end
    end

    describe 'capture' do
      let!(:charge) do
        payjp_stub(:charge, :retrieve)
        Payjp::Charge.retrieve('ch_xxxxx')
      end

      context 'when parameter `amount` is specified' do
        specify do
          payjp_stub(:charge, :capture, params: { amount: 1000 }, source: { amount: 3000 })
          response = charge.capture(amount: 1000)

          expect(response.captured).to be_truthy
          expect(response.refunded).to be_truthy
          expect(response.amount_refunded).to eq 2000
        end
      end

      context "when parameter `amount` isn't specified" do
        specify do
          payjp_stub(:charge, :capture)
          response = charge.capture

          expect(response.captured).to be_truthy
          expect(response.refunded).to be_falsy
          expect(response.amount_refunded).to eq 0
        end
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:charges, :all, source: { description: 'description' })
        response = Payjp::Charge.all

        expect(response.data.first.description).to eq 'description'
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
        payjp_stub(:customer, :retrieve, source: { description: 'description' })
        customer = Payjp::Customer.retrieve('cus_xxxxx')

        expect(customer.description).to eq 'description'
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:customer, :retrieve)
        customer = Payjp::Customer.retrieve('cus_xxxxx')

        payjp_stub(:customers, :save,
          params: { description: 'description' }, source: { id: 'cus_xxxxx' }
        )
        customer.description = 'description'

        response = customer.save

        expect(response.description).to eq 'description'
        expect(response.id).to eq 'cus_xxxxx'
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
        payjp_stub(:customers, :all, source: { description: 'description' })
        response = Payjp::Customer.all

        expect(response.data.first.description).to eq 'description'
      end
    end

    describe 'cards' do
      let!(:customer) do
        payjp_stub(:customer, :retrieve)
        Payjp::Customer.retrieve('cus_xxxxx')
      end

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
          payjp_stub({ customer: :card }, :retrieve, source: { last4: '0000' })
          card = customer.cards.retrieve('car_xxxxx')

          expect(card.last4).to eq '0000'
        end
      end

      describe 'save' do
        specify do
          payjp_stub({ customer: :card }, :retrieve)
          card = customer.cards.retrieve('car_xxxxx')

          payjp_stub({ customer: :card }, :save,
            params: { exp_year: 2038, exp_month: 1 }, source: { exp_year: 2017 }
          )
          card.exp_year  = 2038
          card.exp_month = 1

          response = card.save

          expect(response.exp_year).to eq 2038
          expect(response.exp_month).to eq 1
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
          payjp_stub({ customer: :cards }, :all, source: { customer: customer.id })
          response = customer.cards.all

          expect(response.data.first.customer).to eq customer.id
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
        payjp_stub(:plan, :retrieve, source: { amount: 2000 })
        plan = Payjp::Plan.retrieve('pln_xxxxx')

        expect(plan.amount).to eq 2000
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:plan, :retrieve)
        plan = Payjp::Plan.retrieve('pln_xxxxx')

        payjp_stub(:plan, :save, params: { name: 'name' }, source: { interval: 'year' })
        plan.name = 'name'

        response = plan.save

        expect(response.name).to eq 'name'
        expect(response.interval).to eq 'year'
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
        payjp_stub(:plans, :all, source: { interval: 'year' })
        response = Payjp::Plan.all

        expect(response.data.first.interval).to eq 'year'
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
        payjp_stub(:subscription, :retrieve, source: { customer: 'cus_xxxxx' })
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        expect(subscription.customer).to eq 'cus_xxxxx'
      end
    end

    describe 'save' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :save,
          params: { plan: 'pln_xxxxx' }, source: { customer: 'cus_xxxxx' }
        )
        subscription.plan = 'pln_xxxxx'

        response = subscription.save

        expect(response.plan.id).to eq 'pln_xxxxx'
        expect(response.customer).to eq 'cus_xxxxx'
      end
    end

    describe 'pause' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :pause, source: { prorate: true })
        response = subscription.pause

        expect(response.status).to eq 'paused'
        expect(response.paused_at).to be_an Integer
        expect(response.prorate).to be_truthy
      end
    end

    describe 'resume' do
      let!(:subscription) do
        payjp_stub(:subscription, :retrieve)
        Payjp::Subscription.retrieve('sub_xxxxx')
      end

      context 'when parameter `trial_end` is set to a timestamp' do
        specify do
          trial_end = 2145798000

          payjp_stub(:subscription, :resume,
            params: { trial_end: trial_end }, source: { id: 'pln_xxxxx' }
          )
          response = subscription.resume(trial_end: trial_end)

          expect(response.status).to eq 'trial'
          expect(response.resumed_at).to be_an Integer
          expect(response.trial_end).to eq trial_end
          expect(response.id).to eq 'pln_xxxxx'
        end
      end

      context "when parameter `trial_end` isn't specified" do
        specify do
          payjp_stub(:subscription, :resume, params: { prorate: true }, source: { id: 'pln_xxxxx' })
          response = subscription.resume(prorate: true)

          expect(response.status).to eq 'active'
          expect(response.resumed_at).to be_an Integer
          expect(response.trial_end).to be_nil
          expect(response.prorate).to be_truthy
          expect(response.id).to eq 'pln_xxxxx'
        end
      end
    end

    describe 'cancel' do
      specify do
        payjp_stub(:subscription, :retrieve)
        subscription = Payjp::Subscription.retrieve('sub_xxxxx')

        payjp_stub(:subscription, :cancel, source: { customer: 'cus_xxxxx' })
        response = subscription.cancel

        expect(response.status).to eq 'canceled'
        expect(response.canceled_at).to be_an Integer
        expect(response.customer).to eq 'cus_xxxxx'
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
        payjp_stub(:subscriptions, :all, source: { status: 'paused', paused_at: Time.now.to_i })
        response = Payjp::Subscription.all

        expect(response.data.first.status).to eq 'paused'
        expect(response.data.first.paused_at).to be_an Integer
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
        payjp_stub(:token, 'retrieve', source: { used: true })
        token = Payjp::Token.retrieve('tok_xxxxx')

        expect(token.used).to be_truthy
      end
    end
  end

  describe 'transfers' do
    describe 'retrieve' do
      specify do
        payjp_stub(:transfer, :retrieve, source: { amount: 1000 })
        transfer = Payjp::Transfer.retrieve('tr_xxxxx')

        expect(transfer.amount).to eq 1000
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:transfers, :all, source: { amount: 2000 })
        response = Payjp::Transfer.all

        expect(response.data.first.amount).to eq 2000
      end
    end

    describe 'chrages' do
      describe 'all' do
        specify do
          payjp_stub(:transfer, :retrieve)
          transfer = Payjp::Transfer.retrieve('tr_xxxxx')

          payjp_stub({ transfer: :charges }, :all, source: { paid: true })
          response = transfer.charges.all

          expect(response.data.first.paid).to be_truthy
        end
      end
    end
  end

  describe 'events' do
    describe 'retrieve' do
      specify do
        payjp_stub(:event, :retrieve, source: { id: 'evnt_xxxxx' })
        event = Payjp::Event.retrieve('evnt_xxxxx')

        expect(event.id).to eq 'evnt_xxxxx'
      end
    end

    describe 'all' do
      specify do
        payjp_stub(:events, :all, source: { pending_webhooks: 0 })
        response = Payjp::Event.all

        expect(response.data.first.pending_webhooks).to eq 0
      end
    end
  end

  describe 'accounts' do
    describe 'retrieve' do
      specify do
        payjp_stub(:account, :retrieve, source: { id: 'acct_xxxxx' })
        account = Payjp::Account.retrieve

        expect(account.id).to eq 'acct_xxxxx'
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
