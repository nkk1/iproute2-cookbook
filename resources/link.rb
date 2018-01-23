provides :ip_link

property :device, String, name_property: true
property :mtu, Integer
property :type, String
property :state, String
property :mac, String
property :netns, String
property :alias, String
property :txqueuelen, Integer

property :promisc, [true, false]
property :allmulticast, [true, false]
property :dynamice, [true, false]
property :multicast, [true, false]

default_action :set

load_current_value do |current|
  link = IPRoute::Link.new(current.device, current.netns)
  current_value_does_not_exist! unless link.exist_in_netns?
  mtu link.mtu
  state link.state
  mac link.mac
end

action :add do
  msg = "add link #{new_resource.device}"
  link = IPRoute::Link.new(new_resource.device, new_resource.netns)
  converge_by(msg) { link.create(new_resource.type) } unless link.exist_in_netns?
  action_set
end

action :set do
  link = IPRoute::Link.new(new_resource.device, new_resource.netns)
  netns = IPRoute::Netns.new(new_resource.netns)
  if property_is_set?(:netns)
    converge_by("create netns #{new_resource.netns}") { netns.add } unless netns.exist?
    converge_by("add link #{new_resource.device} to netns #{new_resource.netns}") \
      { link.add_to_netns } unless link.exist_in_netns?
  end
  converge_if_changed(:mtu) { link.mtu = new_resource.mtu } if property_is_set?(:mtu)
  converge_if_changed(:mac) { link.mac = new_resource.mac } if property_is_set?(:mac)
  converge_if_changed(:state) { link.state = new_resource.state } if property_is_set?(:state)
  # converge_if_changed(:alias) { link.alias = new_resource.alias } if property_is_set?(:alias)
end

action :down do
  link = IPRoute::Link.new(new_resource.device, new_resource.netns)
  if link.exist_in_netns?
    link = IPRoute::Link.new(new_resource.device, new_resource.netns)
    converge_by("ip link set dev #{new_resource.device} down") { link.down } unless link.down?
  end
end
