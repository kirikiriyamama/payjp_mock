module PayjpMock::Response::Resource
  class Customer < Base
    PREFIX = 'cus'.freeze
    OBJECT = 'customer'.freeze

    def default_attributes
      id = generate_resource_id(PREFIX)

      {
        cards:         PayjpMock::Response::List.new("/customers/#{id}/cards").to_h,
        created:       Time.now.to_i,
        default_card:  nil,
        description:   'test',
        email:         nil,
        id:            id,
        livemode:      false,
        metadata:      nil,
        object:        OBJECT,
        subscriptions: PayjpMock::Response::List.new("/customers/#{id}/subscriptions").to_h
      }
    end

    def override(attributes)
    end
  end
end
