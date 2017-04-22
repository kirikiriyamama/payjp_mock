module PayjpMock::Response::Resource
  class Subscription < Base
    using PayjpMock::Ext::Integer

    PREFIX = 'sub'.freeze
    OBJECT = 'subscription'.freeze

    def default_attributes
      now = Time.now.to_i

      {
        canceled_at:          nil,
        created:              now,
        current_period_end:   now + 15.days,
        current_period_start: now - 15.days,
        customer:             generate_resource_id(Customer::PREFIX),
        id:                   generate_resource_id(PREFIX),
        livemode:             false,
        metadata:             nil,
        object:               OBJECT,
        paused_at:            nil,
        plan:                 Plan.new.to_h,
        resumed_at:           nil,
        start:                now - 15.days,
        status:               'active',
        trial_end:            nil,
        trial_start:          nil,
        prorate:              false
      }
    end
  end
end
