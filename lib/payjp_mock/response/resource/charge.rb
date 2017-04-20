module PayjpMock::Response::Resource
  class Charge < Base
    PREFIX = 'ch'.freeze
    OBJECT = 'charge'.freeze

    def default_attributes
      now = Time.now.to_i

      {
        amount:          3500,
        amount_refunded: 0,
        captured:        true,
        captured_at:     now,
        card:            Card.new.to_h,
        created:         now,
        currency:        'jpy',
        customer:        nil,
        description:     nil,
        expired_at:      nil,
        failure_code:    nil,
        failure_message: nil,
        id:              generate_resource_id(PREFIX),
        livemode:        false,
        metadata:        nil,
        object:          OBJECT,
        paid:            true,
        refund_reason:   nil,
        refunded:        false,
        subscription:    nil
      }
    end
  end
end
