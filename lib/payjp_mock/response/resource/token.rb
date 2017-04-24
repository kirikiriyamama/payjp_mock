module PayjpMock
  module Response::Resource
    class Token < Base
      PREFIX = 'tok'.freeze
      OBJECT = 'token'.freeze

      def default_attributes
        {
          card:     Card.new.to_h,
          created:  Time.now.to_i,
          id:       generate_resource_id(PREFIX),
          livemode: false,
          object:   OBJECT,
          used:     false
        }
      end
    end
  end
end
