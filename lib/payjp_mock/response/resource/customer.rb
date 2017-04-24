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

    def canonicalize(key, value)
      case key
      when :card
        cards = PayjpMock::Response::List.new("/customers/#{@attributes[:id]}/cards", count: 1) do
          Card.new(value.is_a?(Hash) ? value : {})
        end
        { cards: cards.to_h, default_card: cards.attributes[:data][0][:id] }
      when :default_card
        cards = PayjpMock::Response::List.new("/customers/#{@attributes[:id]}/cards", count: 1) do
          Card.new(id: value)
        end
        { cards: cards.to_h, default_card: value }
      else
        super
      end
    end
  end
end
