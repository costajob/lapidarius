require "lapidarius/gem"
require "lapidarius/command"

module Lapidarius
  class Cutter
    def initialize(gem:, include_dev: false, cmd_klass: Command)
      @gem = gem
      @include_dev = include_dev
      @cmd = cmd_klass.new
    end

    def call(src = cmd, gem = nil)
      tokens = tokenize(src)
      token = tokens.shift
      gem ||= Gem.factory(token)
      tokens.each do |t|
        dep = Gem.factory(t)
        next unless dep
        gem << dep
        call(cmd(dep.name), dep)
      end
      gem
    end

    private def tokenize(src)
      src = src.split(/\n\n/).first
      src.split("\n").tap do |tokens|
        tokens.map!(&:strip)
        tokens.reject! { |token| token.match(/#{Env::DEVELOPMENT}/) } unless @include_dev
      end
    end

    private def cmd(gem = @gem)
      @cmd.call(gem)
    end
  end
end
