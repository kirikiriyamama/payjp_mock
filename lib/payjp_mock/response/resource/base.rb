require 'payjp_mock/ext'
require 'payjp_mock/util'

module PayjpMock
  class Response::Resource::Base < Response::Base
    include Util

    def initialize(attributes = {})
      @attributes = default_attributes.merge(attributes.symbolize_keys)
    end
  end
end
