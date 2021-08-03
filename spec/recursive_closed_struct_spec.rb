require_relative "spec_helper"

require_relative "../lib/prawn_cocktail/utils/recursive_closed_struct"

describe RecursiveClosedStruct do
  it "provides readers from a hash" do
    subject = RecursiveClosedStruct.new(key: "value")
    assert_equal "value", subject.key
  end

  it "raises when there's no such key" do
    subject = RecursiveClosedStruct.new(key: "value")
    assert_raises(NoMethodError) do
      subject.other_key
    end
  end

  it "recurses through hashes" do
    subject = RecursiveClosedStruct.new({
      one: { two: { three: "four" } },
    })
    assert_equal "four", subject.one.two.three
  end

  describe "#include?" do
    it "is true if that key exists" do
      subject = RecursiveClosedStruct.new(real: true)
      assert subject.include?(:real)
    end

    it "is false if that key does not exist" do
      subject = RecursiveClosedStruct.new(real: true)
      refute subject.include?(:imaginary)
    end

    it "recurses" do
      subject = RecursiveClosedStruct.new(one: { two: "three" })
      assert subject.one.include?(:two)
    end
  end
end
