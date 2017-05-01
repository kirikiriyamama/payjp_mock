module PayjpMock
  class RequestBuilder
    include Util
    using   Ext::Hash

    def initialize(resource, operation, params, source, error, response)
      @resource  = resource.is_a?(Hash) ? resource.symbolize_keys : resource.to_sym
      @operation = operation.to_sym
      @params    = params.symbolize_keys
      @source    = source.symbolize_keys

      @response = response ||
        case error&.to_sym
        when :card_error
          Response::Error::CardError.new
        when :invalid_request_error
          Response::Error::InvalidRequestError.new
        when :authentication_error
          Response::Error::AuthenticationError.new
        when :api_connection_error
          Response::Error::ApiConnectionError.new
        when :api_error
          Response::Error::ApiError.new
        end
    end

    def build
      method, path_pattern, success_resp =
        case @resource
        when :charge, :charges
          case @operation
          when :create
            [:post, '/charges', Response::Resource::Charge.new(@params)]
          when :retrieve
            [:get, '/charges/{id}', Response::Resource::Charge.new(@source)]
          when :save
            charge = Response::Resource::Charge.new(@source).set(@params)
            [:post, '/charges/{id}', charge]
          when :refund
            charge = Response::Resource::Charge.new(@source)
            charge
              .set(@params.except(:amount))
              .set(amount_refunded: @params[:amount] || charge.attributes[:amount], refunded: true)

            [:post, '/charges/{id}/refund', charge]
          when :reauth
            charge = Response::Resource::Charge.new(@source)
            charge.set(
              captured:    false,
              captured_at: nil,
              expiry_days: @params[:expiry_days] || 7
            )
            [:post, '/charges/{id}/reauth', charge]
          when :capture
            charge = Response::Resource::Charge.new(@source)
            charge.set(captured: true, captured_at: Time.now.to_i)
            charge.set(
              if @params[:amount]
                { amount_refunded: charge.attributes[:amount] - @params[:amount], refunded: true }
              else
                { amount_refunded: 0, refunded: false }
              end
            )
            [:post, '/charges/{id}/capture', charge]
          when :all
            list = Response::List.new('/charges') { Response::Resource::Charge.new(@source) }
            [:get, '/charges', list]
          else
            raise UnknownOperation, @operation
          end
        when :customer, :customers
          case @operation
          when :create
            [:post, '/customers', Response::Resource::Customer.new(@params)]
          when :retrieve
            [:get, '/customers/{id}', Response::Resource::Customer.new(@source)]
          when :save
            customer = Response::Resource::Customer.new(@source).set(@params)
            [:post, '/customers/{id}', customer]
          when :delete
            cus_id = generate_resource_id(Response::Resource::Customer::PREFIX)
            [:delete, '/customers/{id}', Response::Deleted.new(cus_id)]
          when :all
            list = Response::List.new('/customers') { Response::Resource::Customer.new(@source) }
            [:get, '/customers', list]
          else
            raise UnknownOperation, @operation
          end
        when { customer: :card }, { customer: :cards }, { customers: :card }, { customers: :cards }
          case @operation
          when :create
            [:post, '/customers/{customer_id}/cards', Response::Resource::Card.new(@params)]
          when :retrieve
            card = Response::Resource::Card.new(@source)
            [:get, '/customers/{customer_id}/cards/{id}', card]
          when :save
            card = Response::Resource::Card.new(@source).set(@params)
            [:post, '/customers/{customer_id}/cards/{id}', card]
          when :delete
            car_id = generate_resource_id(Response::Resource::Card::PREFIX)
            [:delete, '/customers/{customer_id}/cards/{id}', Response::Deleted.new(car_id)]
          when :all
            cus_id = generate_resource_id(Response::Resource::Customer::PREFIX)
            list = Response::List.new("/customres/#{cus_id}/cards") do
              Response::Resource::Card.new(@source)
            end
            [:get, '/customers/{customer_id}/cards', list]
          else
            raise UnknownOperation, @operation
          end
        when :plan, :plans
          case @operation
          when :create
            [:post, '/plans', Response::Resource::Plan.new(@params)]
          when :retrieve
            [:get, '/plans/{id}', Response::Resource::Plan.new(@source)]
          when :save
            plan = Response::Resource::Plan.new(@source).set(@params)
            [:post, '/plans/{id}', plan]
          when :delete
            pln_id = generate_resource_id(Response::Resource::Plan::PREFIX)
            [:delete, '/plans/{id}', Response::Deleted.new(pln_id)]
          when :all
            list = Response::List.new('/plans') { Response::Resource::Plan.new(@source) }
            [:get, '/plans', list]
          else
            raise UnknownOperation, @operation
          end
        when :subscription, :subscriptions
          case @operation
          when :create
            subscription =
              if @params[:trial_end] == 'now'
                warn('parameter `trial_end` cannot be set to `now` yet')
                Response::Resource::Subscription.new(@params.except(:trial_end))
              else
                Response::Resource::Subscription.new(@params)
              end
            [:post, '/subscriptions', subscription]
          when :retrieve
            [:get, '/subscriptions/{id}', Response::Resource::Subscription.new(@source)]
          when :save
            subscription = Response::Resource::Subscription.new(@source)
            subscription.set(
              if @params[:trial_end] == 'now'
                warn('parameter `trial_end` cannot be set to `now` yet')
                @params.except(:trial_end)
              else
                @params
              end
            )
            [:post, '/subscriptions/{id}', subscription]
          when :pause
            subscription = Response::Resource::Subscription.new(@source)
            subscription.set(status: 'paused', paused_at: Time.now.to_i)

            [:post, '/subscriptions/{id}/pause', subscription]
          when :resume
            subscription = Response::Resource::Subscription.new(@source)
            subscription.set(resumed_at: Time.now.to_i)

            case @params[:trial_end]
            when nil
              subscription.set(@params).set(status: 'active')
            when 'now'
              warn('parameter `trial_end` cannot be set to `now` yet')
              subscription.set(@params.except(:trial_end)).set(status: 'active')
            else
              subscription.set(@params)
            end

            [:post, '/subscriptions/{id}/resume', subscription]
          when :cancel
            subscription = Response::Resource::Subscription.new(@source)
            subscription.set(status: 'canceled', canceled_at: Time.now.to_i)

            [:post, '/subscriptions/{id}/cancel', subscription]
          when :delete
            sub_id = generate_resource_id(Response::Resource::Subscription::PREFIX)
            [:delete, '/subscriptions/{id}', Response::Deleted.new(sub_id)]
          when :all
            list = Response::List.new('/subscriptions') do
              Response::Resource::Subscription.new(@source)
            end
            [:get, '/subscriptions', list]
          else
            raise UnknownOperation, @operation
          end
        when :token, :tokens
          case @operation
          when :create
            [:post, '/tokens', Response::Resource::Token.new(@params)]
          when :retrieve
            [:get, '/tokens/{id}', Response::Resource::Token.new(@source)]
          else
            raise UnknownOperation, @operation
          end
        when :transfer, :transfers
          case @operation
          when :retrieve
            [:get, '/transfers/{id}', Response::Resource::Transfer.new(@source)]
          when :all
            list = Response::List.new('/transfers') { Response::Resource::Transfer.new(@source) }
            [:get, '/transfers', list]
          else
            raise UnknownOperation, @operation
          end
        when { transfer: :charge }, { transfer: :charges }, { transfers: :charge }, { transfers: :charges }
          case @operation
          when :all
            tr_id = generate_resource_id(Response::Resource::Transfer::PREFIX)
            list = Response::List.new("/transfers/#{tr_id}/charges") do
              Response::Resource::Charge.new(@source)
            end
            [:get, '/transfers/{transfer_id}/charges', list]
          else
            raise UnknownOperation, @operation
          end
        when :event, :events
          case @operation
          when :retrieve
            [:get, '/events/{id}', Response::Resource::Event.new(@source)]
          when :all
            list = Response::List.new('/events') { Response::Resource::Event.new(@source) }
            [:get, '/events', list]
          else
            raise UnknownOperation, @operation
          end
        when :account, :accounts
          case @operation
          when :retrieve
            [:get, '/accounts', Response::Resource::Account.new(@source)]
          else
            raise UnknownOperation, @operation
          end
        else
          raise UnknownResource, @resource
        end

      Request.new(method, path_pattern, @params, @response || success_resp)
    end

    UnknownResource  = Class.new(StandardError)
    UnknownOperation = Class.new(StandardError)
  end
end
