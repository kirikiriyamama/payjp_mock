module PayjpMock::Response::Error
  class InvalidRequestError < Base
    def default_attributes
      {
        code:    'missing_param',
        message: 'Missing required param to charge',
        param:   'amount',
        status:  status,
        type:    'client_error'
      }
    end

    def status
      400
    end
  end
end
