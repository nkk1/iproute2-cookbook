module IPRoute
  class VLAN < Link
    def initialize(dev, link, id, netns = nil)
      super(dev, netns)
      @id = id
      @link = link
      @type = 'vlan'
    end

    def create
      shellout("#{ip} link add dev #{@dev} link #{@link} type #{@type} id #{@id}")
    end

    def exist_in_netns?
      links = shellout("#{netns_exec}#{ip} -o link")
      links.each_line { |l| return true if link_name(l) == @dev }
      false
    end

    def exist?
      links = shellout("#{ip} -o link")
      links.each_line { |l| return true if link_name(l) == @dev }
      false
    end

    private

    def link_name(name)
      name.split[1].split('@')[0]
    end
  end

  class Dummy < Link
    def initialize(dev, netns = nil)
      super(dev, netns)
      @type = 'dummy'
    end

    def create
      shellout("#{ip} link add dev #{@dev} type #{@type}")
    end
  end

  class VEth < Link
    def initialize(dev, peer, netns = nil)
      super(dev, netns)
      @peer = peer
      @type = 'veth'
    end

    def create
      shellout("#{ip} link add dev #{@dev} type #{@type} peer name #{@peer}")
    end

    def exist_in_netns?
      links = shellout("#{netns_exec}#{ip} -o link")
      links.each_line { |l| return true if link_name(l) == @dev }
      false
    end

    def exist?
      links = shellout("#{ip} -o link")
      links.each_line { |l| return true if link_name(l) == @dev }
      false
    end

    private

    def link_name(name)
      name.split[1].split('@')[0]
    end
  end
end
