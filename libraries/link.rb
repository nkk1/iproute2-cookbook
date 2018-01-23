module IPRoute
  class Link
    def initialize(dev, netns = nil)
      @dev = dev
      @netns = netns
    end

    def create(type)
      shellout("#{ip} link add dev #{@dev} type #{type}")
    end

    def exist_in_netns?
      links = shellout("#{netns_exec} #{ip} -o link")
      links.each_line { |l| return true if l.split[1] == "#{@dev}:" }
      false
    end

    def exist?
      links = shellout("#{ip} -o link")
      links.each_line { |l| return true if l.split[1] == "#{@dev}:" }
      false
    end

    def down
      shellout("#{netns_exec} #{ip} link set dev #{@dev} down")
    end

    def up
      shellout("#{netns_exec} #{ip} link set dev #{@dev} up")
    end

    def up?
      state == 'up' ? true : false
    end

    def down?
      state == 'down' ? true : false
    end

    def state
      next_word(link.split, 'state').downcase
    end

    def state=(new_state)
      shellout("#{netns_exec} #{ip} link set dev #{@dev} #{new_state}")
    end

    def mtu=(new_mtu)
      shellout("#{netns_exec} #{ip} link set dev #{@dev} mtu #{new_mtu}")
    end

    def mtu
      next_word(link.split, 'mtu').to_i
    end

    def add_to_netns
      shellout("ip link set dev #{@dev} netns #{@netns}")
    end

    def mac=(new_mac)
      shellout("ip link set dev #{@dev} address #{new_mac}")
    end

    def mac
      next_word(link.split, 'link/ether')
    end

    private

    def netns_exec
      @netns ? "ip netns exec #{@netns}" : ''
    end

    def link
      shellout("#{netns_exec} #{ip} -o link show #{@dev}")
    end

    def ip
      '/sbin/ip'
    end

    def next_word(words, word)
      words[words.index(word) + 1]
    end

    def shellout(cmd)
      IPRoute.shellout(cmd)
    end
  end
end
