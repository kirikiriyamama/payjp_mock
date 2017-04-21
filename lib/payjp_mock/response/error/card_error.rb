module PayjpMock::Response::Error
  class CardError < Base
    def default_attributes
      {
        code:    'invalid_number',
        message: 'Invalid card number',
        param:   'card[number]',
        status:  status,
        type:    'card_error'
      }
    end

    def status
      402
    end
  end
end
