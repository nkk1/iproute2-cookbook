include_recipe 'iproute2'

ip_link 'dumb0' do
  type 'dummy'
  state 'down'
end

ip_link 'dumb1' do
  type 'dummy'
  mtu 1400
  state 'up'
end
