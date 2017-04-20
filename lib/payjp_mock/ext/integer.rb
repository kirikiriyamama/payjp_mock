module IntegerExtension
  def days
    self * 24 * 60 * 60
  end
  alias :day :days
end

Integer.send(:include, IntegerExtension)
