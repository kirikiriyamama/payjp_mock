module PayjpMock::Response::Error
  class ApiError < Base
    def default_attributes
      {
        code:    'under_maintenance',
        message: 'PAY.JP is currently undergoing maintenance. Please try again later.',
        status:  status,
        type:    'server_error'
      }
    end

    def status
      503
    end
  end
end
