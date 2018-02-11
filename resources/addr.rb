provides :ip_addr

property :device, String, name_property: true
property :ip, [String, Array], required: true
property :netns, String

action :add do
  ips = IPRoute::Utils.format_ip(new_resource.ip)
  ips.each do |ip|
    addr = IPRoute::Address.new(new_resource.device, ip, new_resource.netns)
    converge_by("Add #{ip} to #{new_resource.device}") { addr.add } unless addr.exist?
  end
end

action :delete do
  ips = IPRoute::Utils.format_ip(new_resource.ip)
  ips.each do |ip|
    addr = IPRoute::Address.new(new_resource.device, ip, new_resource.netns)
    converge_by("Delete #{ip} from #{new_resource.device}") { addr.delete } if addr.exist?
  end
end

action :flush do
  addr = IPRoute::Address.new(new_resource.device, [], new_resource.netns)
  device_ips = addr.ips
  converge_by("Flush #{new_resource.device}") { addr.flush } unless device_ips.empty?
end

action :flush_and_set do
  addr = IPRoute::Address.new(new_resource.device, [], new_resource.netns)
  device_ips = addr.ips
  if device_ips.sort != new_resource.ip
    converge_by("Flush #{new_resource.device}") do
      addr.flush
      action_add
    end
  end
end
