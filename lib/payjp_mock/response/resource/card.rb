module PayjpMock
  module Response::Resource
    class Card < Base
      PREFIX = 'car'.freeze
      OBJECT = 'card'.freeze

      def default_attributes
        {
          address_city:      nil,
          address_line1:     nil,
          address_line2:     nil,
          address_state:     nil,
          address_zip:       nil,
          address_zip_check: 'unchecked',
          brand:             'Visa',
          country:           nil,
          created:           Time.now.to_i,
          customer:          generate_resource_id(Customer::PREFIX),
          cvc_check:         'unchecked',
          exp_month:         2,
          exp_year:          2020,
          fingerprint:       generate_fingerprint,
          id:                generate_resource_id(PREFIX),
          last4:             '4242',
          livemode:          false,
          metadata:          nil,
          name:              nil,
          object:            OBJECT
        }
      end

      def canonicalize(key, value)
        case key
        when :number
          { last4: value[-4..-1] }
        when :cvc
          {}
        else
          super
        end
      end
    end
  end
end
