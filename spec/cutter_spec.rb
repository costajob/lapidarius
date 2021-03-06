require "helper"

describe Lapidarius::Cutter do
  let(:cutter) { Lapidarius::Cutter.new(name: "sinatra", cmd_klass: Stubs::Command, version: "1.4.7", remote: true) }

  it "must set options" do
    cutter.version.must_equal "1.4.7"
    cutter.remote.must_equal true
  end

  it "must cut gem with runtime dependencies" do
    gem = cutter.call
    gem.must_be_instance_of Lapidarius::Gem
    gem.deps.size.must_equal 3
    gem.deps.each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must compute development dependencies count" do
    gem = cutter.call
    gem.dev_count.must_equal 7
  end

  it "must raise kind error if no gem can created" do
    cutter = Lapidarius::Cutter.new(name: "raise_error", cmd_klass: Stubs::Command)
    -> { cutter.call }.must_raise Lapidarius::Gem::KindError
  end
end
