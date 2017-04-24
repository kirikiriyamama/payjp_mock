module PayjpMock
  module Response::Resource
    class Charge < Base
      using Ext::Integer

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

      def canonicalize(key, value)
        case key
        when :card
          { card: Card.new(value.is_a?(Hash)? value : {}).to_h }
        when :capture
          { captured: value, captured_at: value ? Time.now.to_i : nil }
        when :expiry_days
          expired_at =
            if value == 60
              expired_date = Time.now + 59.days
              Time.local(expired_date.year, expired_date.month, expired_date.day, 23, 59, 59)
            else
              Time.now + value.days
            end
          { expired_at: expired_at.to_i }
        else
          super
        end
      end
    end
  end
end
