module PayjpMock
  module Response::Resource
    class Plan < Base
      PREFIX = 'pln'.freeze
      OBJECT = 'plan'.freeze

      def default_attributes
        {
          amount:      500,
          billing_day: nil,
          created:     Time.now.to_i,
          currency:    'jpy',
          id:          generate_resource_id(PREFIX),
          interval:    'month',
          livemode:    false,
          metadata:    nil,
          name:        nil,
          object:      OBJECT,
          trial_days:  30
        }
      end
    end
  end
end
