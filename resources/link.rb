provides :ip_link

property :device, String, required: true, name_property: true
property :mtu, Integer
property :type, String
property :state, String

default_action :set

load_current_value do |current|
  link = IPRoute::Link.new(current.device)
  current_value_does_not_exist! unless link.exist?
  mtu link.mtu
  state link.state
end

action :add do
  link = IPRoute::Link.new(new_resource.device)
  link.create(new_resource.type) unless link.exist?
end

action :set do
  link = IPRoute::Link.new(new_resource.device)
  converge_if_changed(:mtu) { link.mtu = new_resource.mtu } if property_is_set?(:mtu)
  converge_if_changed(:state) { link.state = new_resource.state } if property_is_set?(:state)
end

action :down do
  link = IPRoute::Link.new(new_resource.device)
  if link.exist?
    link = IPRoute::Link.new(new_resource.device)
    converge_by("ip link set dev #{new_resource.device} down") { link.down } unless link.down?
  end
end
