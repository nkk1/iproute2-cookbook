include_recipe 'iproute2'

ip_link 'dumb0' do
  action [:add, :set]
  type 'dummy'
  state 'down'
end

ip_link 'dumb1' do
  action [:add, :set]
  type 'dummy'
  mtu 1400
  state 'up'
end
