module PayjpMock
  module Response::Resource
    class Account < Base
      PREFIX = 'acct'.freeze
      OBJECT = 'account'.freeze

      def default_attributes
        {
          created:  Time.now.to_i,
          email:    'liveaccount@example.com',
          id:       generate_resource_id(PREFIX),
          merchant: Merchant.new.to_h,
          object:   OBJECT
        }
      end
    end
  end
end
