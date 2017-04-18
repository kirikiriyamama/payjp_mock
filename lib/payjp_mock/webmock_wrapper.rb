require 'payjp_mock/request_builder'

module PayjpMock
  module WebMockWrapper
    def payjp_stub(resource, operation)
      builder = RequestBuilder.new(resource, operation)
      request = builder.build
      request.stub
    end
  end
end
