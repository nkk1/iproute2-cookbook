provides :ip_link

property :device, String, name_property: true
property :mtu, Integer
property :type, String
property :state, String, default: 'up'
property :mac, String
property :netns, String
property :alias_name, String
property :qlen, Integer
property :link, String
property :id, Integer
property :peer, String

# property :promisc, [true, false]
# property :allmulticast, [true, false]
# property :dynamice, [true, false]
# property :multicast, [true, false]

default_action :add

load_current_value do |current|
  link = IPRoute.get_link_object(current)
  current_value_does_not_exist! unless link.exist_in_netns?
  mtu link.mtu
  state link.state
  mac link.mac
  alias_name link.alias
  qlen link.qlen
end

action :add do
  msg = "add link #{new_resource.device}"
  link = nil
  link = IPRoute.get_link_object(new_resource)
  converge_by(msg) { link.create } unless link.exist_in_netns? || link.exist?
  action_set
end

action :set do
  link = IPRoute.get_link_object(new_resource)
  if property_is_set?(:netns)
    converge_by("add link #{new_resource.device} to netns #{new_resource.netns}") \
      { link.add_to_netns } unless link.exist_in_netns?
  end
  converge_if_changed(:mtu) { link.mtu = new_resource.mtu } if property_is_set?(:mtu)
  converge_if_changed(:mac) { link.mac = new_resource.mac } if property_is_set?(:mac)
  converge_if_changed(:state) { link.state = new_resource.state } if property_is_set?(:state)
  converge_if_changed(:alias_name) { link.alias = new_resource.alias_name } if property_is_set?(:alias_name)
  converge_if_changed(:qlen) { link.qlen = new_resource.qlen } if property_is_set?(:qlen)
end

action :down do
  link = IPRoute.get_link_object(new_resource)
  if link.exist_in_netns?
    link = IPRoute::Link.new(new_resource.device, new_resource.netns)
    converge_by("ip link set dev #{new_resource.device} down") { link.down } unless link.down?
  end
end

action :delete do
  link = IPRoute.get_link_object(new_resource)
  converge_if_changed(:state) { link.state = new_resource.state } if property_is_set?(:state)
  link.delete
end
