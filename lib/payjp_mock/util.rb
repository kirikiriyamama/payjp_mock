require 'securerandom'

module PayjpMock::Util
  def generate_resource_id(prefix)
    "#{prefix}_#{SecureRandom.hex(14)}"
  end

  def generate_fingerprint
    SecureRandom.hex(16)
  end
end
