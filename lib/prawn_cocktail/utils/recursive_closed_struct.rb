class RecursiveClosedStruct
  def initialize(hash)
    @hash = hash
  end

  def include?(key)
    @hash.include?(key)
  end

  def method_missing(name, *)
    value = fetch(name)
    if value.is_a?(Hash)
      self.class.new(value)
    else
      value
    end
  end

  private

  def fetch(name)
    @hash.fetch(name) do
      raise NoMethodError.new("undefined method `#{name}' for #{self}")
    end
  end
end
