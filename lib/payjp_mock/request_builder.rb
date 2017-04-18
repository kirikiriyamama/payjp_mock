require 'payjp_mock/ext/hash'
require 'payjp_mock/request'
require 'payjp_mock/response'

module PayjpMock
  class RequestBuilder
    BASE_URL = 'https://api.pay.jp/v1'.freeze

    def initialize(resource, operation)
      @resource  = resource.is_a?(Hash) ? resource.symbolize_keys : resource.to_sym
      @operation = operation.to_sym
    end

    def build
      method, path_pattern =
        case @resource
        when :charge, :charges
          case @operation
          when :create
            [:post, '/charges']
          when :retrieve
            [:get, '/charges/{id}']
          when :save
            [:post, '/charges/{id}']
          when :refund
            [:post, '/charges/{id}/refund']
          when :reauth
            [:post, '/charges/{id}/reauth']
          when :capture
            [:post, '/charges/{id}/capture']
          when :all
            [:get, '/charges']
          else
            raise UnknownOperation, @operation
          end
        when :customer, :customers
          case @operation
          when :create
            [:post, '/customers']
          when :retrieve
            [:get, '/customers/{id}']
          when :save
            [:post, '/customers/{id}']
          when :delete
            [:delete, '/customers/{id}']
          when :all
            [:get, '/customers']
          else
            raise UnknownOperation, @operation
          end
        when { customer: :card }, { customer: :cards }, { customers: :card }, { customers: :cards }
          case @operation
          when :create
            [:post, '/customers/{customer_id}/cards']
          when :retrieve
            [:get, '/customers/{customer_id}/cards/{id}']
          when :save
            [:post, '/customers/{customer_id}/cards/{id}']
          when :delete
            [:delete, '/customers/{customer_id}/cards/{id}']
          when :all
            [:get, '/customers/{customer_id}/cards']
          else
            raise UnknownOperation, @operation
          end
        when :plan, :plans
          case @operation
          when :create
            [:post, '/plans']
          when :retrieve
            [:get, '/plans/{id}']
          when :save
            [:post, '/plans/{id}']
          when :delete
            [:delete, '/plans/{id}']
          when :all
            [:get, '/plans']
          else
            raise UnknownOperation, @operation
          end
        when :subscription, :subscriptions
          case @operation
          when :create
            [:post, '/subscriptions']
          when :retrieve
            [:get, '/subscriptions/{id}']
          when :save
            [:post, '/subscriptions/{id}']
          when :pause
            [:post, '/subscriptions/{id}/pause']
          when :resume
            [:post, '/subscriptions/{id}/resume']
          when :cancel
            [:post, '/subscriptions/{id}/cancel']
          when :delete
            [:delete, '/subscriptions/{id}']
          when :all
            [:get, '/subscriptions']
          else
            raise UnknownOperation, @operation
          end
        when :token, :tokens
          case @operation
          when :create
            [:post, '/tokens']
          when :retrieve
            [:get, '/tokens/{id}']
          else
            raise UnknownOperation, @operation
          end
        when :transfer, :transfers
          case @operation
          when :retrieve
            [:get, '/transfers/{id}']
          when :all
            [:get, '/transfers']
          else
            raise UnknownOperation, @operation
          end
        when { transfer: :charge }, { transfer: :charges }, { transfers: :charge }, { transfers: :charges }
          case @operation
          when :all
            [:get, '/transfers/{transfer_id}/charges']
          else
            raise UnknownOperation, @operation
          end
        when :event, :events
          case @operation
          when :retrieve
            [:get, '/events/{id}']
          when :all
            [:get, '/events']
          else
            raise UnknownOperation, @operation
          end
        when :account, :accounts
          case @operation
          when :retrieve
            [:get, '/accounts']
          else
            raise UnknownOperation, @operation
          end
        else
          raise UnknownResource, @resource
        end

      url_template = Addressable::Template.new(BASE_URL + path_pattern)
      Request.new(method, url_template)
    end

    UnknownResource  = Class.new(StandardError)
    UnknownOperation = Class.new(StandardError)
  end
end
