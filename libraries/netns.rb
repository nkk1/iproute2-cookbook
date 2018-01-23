module IPRoute
  class Netns
    def initialize(name)
      @name = name
    end

    def exist?
      netnses = shellout('ip netns').lines.map(&:chomp!)
      return true if netnses.include?(@name)
      false
    end

    def add
      shellout("ip netns add #{@name}")
    end

    def delete
      shellout("ip netns delete #{@name}")
    end

    private

    def shellout(cmd)
      IPRoute.shellout(cmd)
    end
  end
end
