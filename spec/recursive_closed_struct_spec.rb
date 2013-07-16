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
      one: { two: { three: "four" } }
    })
    assert_equal "four", subject.one.two.three
  end


  it "lets a user check if the key exists without throwing an error" do
    subject = RecursiveClosedStruct.new({
      real: true
    })

    assert subject.has_key?(:real)
  end

  it "lets a user check if the key does not exist without throwing an error" do
    subject = RecursiveClosedStruct.new({
      real: true
    })

    refute subject.has_key?(:imaginary)
  end
end
