module PayjpMock
  module WebMockWrapper
    def payjp_stub(resource, operation, error: nil)
      builder = RequestBuilder.new(resource, operation, error)
      request = builder.build
      request.stub
    end
  end
end
