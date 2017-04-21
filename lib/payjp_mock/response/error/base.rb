module PayjpMock
  class Response::Error::Base < Response::Base
    def initialize
      @attributes = default_attributes
    end

    def body
      { error: @attributes }.to_json
    end
  end
end
