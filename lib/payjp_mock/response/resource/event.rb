module PayjpMock
  module Response::Resource
    class Event < Base
      PREFIX = 'evnt'.freeze
      OBJECT = 'event'.freeze

      def default_attributes
        {
          created:          Time.now.to_i,
          data:             Customer.new.to_h,
          id:               generate_resource_id(PREFIX),
          livemode:         false,
          object:           OBJECT,
          pending_webhooks: 1,
          type:             'customer.updated'
        }
      end
    end
  end
end
