ip_netns 'dead'

ip_netns 'dead' do
  action :delete
end

ip_netns 'vpn'
ip_netns 'space'

ip_link 'vpn0' do
  action [:add, :set]
  type 'dummy'
  state 'down'
  netns 'vpn'
end

ip_link 'vpn1' do
  action [:add, :set]
  type 'dummy'
  mtu 1400
  state 'up'
  netns 'space'
end
