module PayjpMock::Response
  class List < Base
    OBJECT = 'list'.freeze

    def initialize(path, count: 3)
      @attributes = {
        count:    0,
        data:     [],
        has_more: false,
        object:   OBJECT,
        url:      "/#{PayjpMock::Request::API_VERSION}" + path
      }
      return unless block_given?

      @attributes[:count] = count
      @attributes[:data]  = count.times.map { yield.to_h }
    end

    def status
      200
    end
  end
end
