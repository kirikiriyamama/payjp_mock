class PayjpMock::Response::Base
  attr_reader :attributes

  def body
    @attributes.to_json
  end

  def status
    raise NotImplementedError
  end

  def exception
    nil
  end

  def to_h
    @attributes
  end
end
