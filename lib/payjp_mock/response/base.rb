class PayjpMock::Response::Base
  attr_reader :attributes

  def body
    @attributes.to_json
  end

  def to_h
    @attributes
  end
end
