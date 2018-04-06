provides :ip_route

property :dest, String, name_property: true
property :via, String
property :dev, String
property :metric, Integer
property :table, String
property :src, String
property :realm, String
property :mtu, Integer
property :mtu_lock, [TrueClass, FalseClass]
property :window, Integer
property :rtt, String
property :netns, String

load_current_value do |_current|
  route = IPRoute::Route.new(dest, netns)
  current_value_does_not_exist! unless route.exist_in_netns?
end

action :add do
  # route = IPRoute::Route.new(dest, netns)
  # action = route.exist_in_netns? ? 'replace' : 'add'
end

action :del do
end

action :flush do
end
