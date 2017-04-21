module PayjpMock::Response::Error
  class ApiConnectionError < Base
    def initialize
    end

    def body
      nil
    end

    def status
      nil
    end

    def exception
      SocketError
    end
  end
end
