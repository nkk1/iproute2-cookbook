module IPRoute
  class Address
    def initialize(dev, ip_addr, netns = nil)
      @dev = dev
      @ip_addr = ip_addr
      @netns = netns
    end

    def exist?
      ips.include?(@ip_addr)
    end

    def add
      shellout("#{netns_exec}#{ip} addr add dev #{@dev} #{@ip_addr}")
    end

    def delete
      shellout("#{netns_exec}#{ip} addr del dev #{@dev} #{@ip_addr}")
    end

    def flush
      shellout("#{netns_exec}#{ip} addr flush dev #{@dev}")
    end

    def ips
      ip_addrs = []
      lines = shellout("#{netns_exec}#{ip} -o -d addr show #{@dev}")
      lines.each_line { |line| ip_addrs << line.split[3] if line.split[2] == 'inet' }
      ip_addrs
    end

    private

    def netns_exec
      @netns ? "#{ip} netns exec #{@netns} " : ''
    end

    def ip
      '/sbin/ip'
    end

    def shellout(cmd)
      IPRoute::Utils.shellout(cmd)
    end
  end
end
