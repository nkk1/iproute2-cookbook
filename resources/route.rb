provides :ip_route

property :dest, String, name_property: true
property :via, String
property :dev, String
property :metric, Integer
property :table, [Integer, String]
property :src, String
property :realm, [Integer, String]
property :mtu, Integer
property :mtu_lock, [TrueClass, FalseClass]
property :window, Integer
property :rtt, String
property :scope, [Integer, String]
property :netns, String

load_current_value do |_current|
  route = IPRoute::Route.new(dest, netns)
  current_value_does_not_exist! unless route.exist_in_netns?
end

action :add do
  route = get_route_obj(new_resource)
  route.exist_in_netns? ? route.replace : route.add
end

action :delete do
  route = get_route_obj(new_resource)
  route.delete if route.exist_in_netns?
end

action :flush do
  route = get_route_obj(new_resource)
  route.flush if route.exist_in_netns?
end

def get_route_obj(new_resource)
  IPRoute::Route.new(new_resource.dest, new_resource.netns, 'via' => new_resource.via,
                                                                    'dev' => new_resource.dev,
                                                                    'metric' => new_resource.metric,
                                                                    'table' => new_resource.table,
                                                                    'src' => new_resource.src,
                                                                    'realm' => new_resource.realm,
                                                                    'mtu' => new_resource.mtu,
                                                                    'mtu_lock' => new_resource.mtu_lock,
                                                                    'window' => new_resource.window,
                                                                    'rtt' => new_resource.rtt,
                                                                    'scope' => new_resource.scope)
end
