module PayjpMock
  module Response::Resource
    class Merchant < Base
      PREFIX = 'acct_mch'.freeze
      OBJECT = 'merchant'.freeze

      def default_attributes
        {
          bank_enabled:          false,
          brands_accepted:       ['Visa', 'MasterCard', 'JCB', 'American Express', 'Diners Club', 'Discover'],
          business_type:         nil,
          charge_type:           nil,
          contact_phone:         nil,
          country:               'JP',
          created:               Time.now.to_i,
          currencies_supported:  ['jpy'],
          default_currency:      'jpy',
          details_submitted:     false,
          id:                    generate_resource_id(PREFIX),
          livemode_activated_at: nil,
          livemode_enabled:      false,
          object:                OBJECT,
          product_detail:        nil,
          product_name:          nil,
          product_type:          nil,
          site_published:        nil,
          url:                   nil
        }
      end
    end
  end
end
