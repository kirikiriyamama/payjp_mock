module PayjpMock::Response::Error
  class ApiError < Base
    def default_attributes
      {
        message: 'API server is currently unavailable',
        status:  status,
        type:    'server_error'
      }
    end

    def status
      500
    end
  end
end
