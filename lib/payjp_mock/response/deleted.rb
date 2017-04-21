module PayjpMock::Response
  class Deleted < Base
    def initialize(resource_id)
      @attributes = {
        deleted:  true,
        id:       resource_id,
        livemode: false
      }
    end

    def status
      200
    end
  end
end
