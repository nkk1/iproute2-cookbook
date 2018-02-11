require 'mixlib/shellout'

module IPRoute
  class Utils
    def self.shellout(cmd)
      run = Mixlib::ShellOut.new(cmd)
      run.run_command
      if run.error? || run.exitstatus != 0
        raise "#{cmd} failed: \n ----- stderr ----- \n #{run.stderr} \n ------ stdout ----- \n #{run.stdout}"
      end
      run.stdout
    end

    def self.get_link_object(new_resource)
      case new_resource.type
      when 'vlan'
        IPRoute::VLAN.new(new_resource.device, new_resource.link, new_resource.id, new_resource.netns)
      when 'dummy'
        IPRoute::Dummy.new(new_resource.device, new_resource.netns)
      when 'veth'
        IPRoute::VEth.new(new_resource.device, new_resource.peer, new_resource.netns)
      else
        IPRoute::Link.new(new_resource.device, new_resource.netns)
      end
    end

    def self.format_ip(addrs)
      ip_addrs = addrs.is_a?(Array) ? addrs : [addrs]
      ip_addrs.map { |i| i.include?('/') ? i : i + '/32' }
    end

    def self.get_device_ips(device, netns)
      IPRoute::Address.new(device, [], netns).ips
    end
  end
end
