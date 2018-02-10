module IPRoute
  class Link
    def initialize(dev, netns = nil)
      @dev = dev
      @netns = netns
    end

    def create
      raise 'IPRoute::Link.create says: Not implemented. Please mention the *type* property'
    end

    def exist_in_netns?
      links = shellout("#{netns_exec}#{ip} -o link")
      links.each_line { |l| return true if l.split[1] == "#{@dev}:" }
      false
    end

    def exist?
      links = shellout("#{ip} -o link")
      links.each_line { |l| return true if l.split[1] == "#{@dev}:" }
      false
    end

    def down
      shellout("#{netns_exec}#{ip} link set dev #{@dev} down")
    end

    def up
      shellout("#{netns_exec}#{ip} link set dev #{@dev} up")
    end

    def up?
      state == 'up' ? true : false
    end

    def down?
      state == 'down' ? true : false
    end

    def state
      next_word('state').downcase
    end

    def state=(new_state)
      shellout("#{netns_exec}#{ip} link set dev #{@dev} #{new_state}")
    end

    def mtu=(new_mtu)
      shellout("#{netns_exec}#{ip} link set dev #{@dev} mtu #{new_mtu}")
    end

    def mtu
      next_word('mtu').to_i
    end

    def add_to_netns
      shellout("#{ip} link set dev #{@dev} netns #{@netns}")
    end

    def mac=(new_mac)
      shellout("#{netns_exec}#{ip} link set dev #{@dev} address #{new_mac}")
    end

    def mac
      next_word('link/ether')
    end

    def alias=(new_alias)
      shellout("#{netns_exec}#{ip} link set dev #{@dev} alias \"#{new_alias}\"")
    end

    def alias
      alias_link = link(false)
      last_line = alias_link.split("\n")[-1].lstrip
      return nil unless last_line.start_with?('alias')
      last_line.split(' ', 2)[1]
    end

    def qlen
      next_word('qlen').to_i if link.include?('qlen')
    end

    def qlen=(new_txqueuelen)
      shellout("#{netns_exec}#{ip} link set dev #{@dev} txqueuelen #{new_txqueuelen}")
    end

    def delete
      shellout("#{netns_exec}#{ip} link delete dev #{@dev}#{@type ? ' type ' + @type : ''}")
    end

    protected

    def netns_exec
      @netns ? "#{ip} netns exec #{@netns} " : ''
    end

    def link(line = true)
      l = line ? '-o' : ''
      shellout("#{netns_exec}#{ip} #{l} -d link show #{@dev}")
    end

    def ip
      '/sbin/ip'
    end

    def next_word(word)
      words = link.split
      words[words.index(word) + 1]
    end

    def shellout(cmd)
      IPRoute::Utils.shellout(cmd)
    end
  end
end
