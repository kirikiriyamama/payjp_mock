module PayjpMock
  class Response::Resource::Base < Response::Base
    include Util

    def initialize(attributes = {})
      @attributes = default_attributes.merge(attributes.symbolize_keys)
    end

    def status
      200
    end
  end
end
