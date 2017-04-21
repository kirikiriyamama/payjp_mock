module PayjpMock::Response::Error
  class AuthenticationError < Base
    def default_attributes
      {
        message: 'Invalid API Key: sk_test_********************xxxx',
        status:  status,
        type:    'auth_error'
      }
    end

    def status
      401
    end
  end
end
