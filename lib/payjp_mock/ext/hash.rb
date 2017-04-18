module HashExtension
  def symbolize_keys
    each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
  end
end

Hash.send(:include, HashExtension)
