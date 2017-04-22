module PayjpMock::Ext
  module Integer
    refine ::Integer do
      def days
        self * 24 * 60 * 60
      end
      alias :day :days
    end
  end
end
