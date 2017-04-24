module PayjpMock
  module WebMockWrapper
    def payjp_stub(resource, operation, params: {}, error: nil)
      builder = RequestBuilder.new(resource, operation, params, error)
      request = builder.build
      request.stub
    end
  end
end
