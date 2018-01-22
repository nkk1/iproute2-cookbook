provides :ip_netns

default_action :add

action :add do
  netns = IPRoute::Netns.new(new_resource.name)
  converge_by("create netns #{new_resource.name}") { netns.add } unless netns.exist?
end

action :delete do
  netns = IPRoute::Netns.new(new_resource.name)
  converge_by("delete netns #{new_resource.name}") { netns.delete } if netns.exist?
end
