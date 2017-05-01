module PayjpMock
  module WebMockWrapper
    def payjp_stub(resource, operation, params: {}, source: {}, error: nil)
      builder = RequestBuilder.new(resource, operation, params, source, error)
      request = builder.build
      request.stub
    end
  end
end
