module PayjpMock
  module WebMockWrapper
    using Ext::Hash

    def payjp_stub(resource, operation, params: {}, source: {}, error: nil, response: nil)
      builder = RequestBuilder.new(resource, operation, params, source, error, response)
      request = builder.build
      request.stub
    end

    def payjp_card_error(attributes = {})
      Response::Error::CardError.new(attributes.symbolize_keys)
    end

    def payjp_invalid_request_error(attributes = {})
      Response::Error::InvalidRequestError.new(attributes.symbolize_keys)
    end

    def payjp_authentication_error(attributes = {})
      Response::Error::AuthenticationError.new(attributes.symbolize_keys)
    end

    def payjp_api_connection_error
      Response::Error::ApiConnectionError.new
    end

    def payjp_api_error(attributes = {})
      Response::Error::ApiError.new(attributes.symbolize_keys)
    end
  end
end
