module PayjpMock
  class Response::Resource::Base < Response::Base
    include Util
    using   Ext::Hash

    def initialize(attributes = {})
      @attributes = default_attributes
      set(attributes.symbolize_keys)
    end

    def set(attributes)
      attributes.each do |k, v|
        @attributes.merge!(canonicalize(k, v))
      end
      self
    end

    def canonicalize(key, value)
      { key => value }
    end

    def status
      200
    end
  end
end
