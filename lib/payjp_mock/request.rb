require 'addressable'
require 'webmock'

module PayjpMock
  Request = Struct.new(:method, :url) do
    include WebMock::API

    def stub
      stub_request(method, url)
    end
  end
end
