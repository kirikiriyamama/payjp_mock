module PayjpMock::Ext
  module Hash
    refine ::Hash do
      def symbolize_keys
        each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
      end

      def deep_transform_values(&block)
        each_with_object({}) do |(k, v), h|
          h[k] = v.is_a?(::Hash) ? v.deep_transform_values(&block) : block.call(v)
        end
      end

      def except(*keys)
        each_with_object({}) { |(k, v), h| h[k] = v unless keys.include?(k) }
      end

      def compact
        reject { |_, v| v.nil? }
      end
    end
  end
end
