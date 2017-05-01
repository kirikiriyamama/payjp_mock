module PayjpMock
  class Response::Error::Base < Response::Base
    using Ext::Hash

    def initialize(code: nil, message: nil, param: nil)
      @attributes = default_attributes.merge(
        { code: code, message: message, param: param }.compact
      )
    end

    def body
      { error: @attributes }.to_json
    end
  end
end
