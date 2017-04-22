module PayjpMock::Ext
  module Hash
    refine ::Hash do
      def symbolize_keys
        each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
      end
    end
  end
end
