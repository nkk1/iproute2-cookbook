require 'mixlib/shellout'

module IPRoute
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
    else
      IPRoute::Link.new(new_resource.device, new_resource.netns)
    end
  end
end
