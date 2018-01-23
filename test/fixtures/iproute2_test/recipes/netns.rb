ip_netns 'dead'

ip_netns 'dead' do
  action :delete
end

ip_netns 'vpn'
ip_netns 'space'

ip_link 'vpn0' do
  action :add
  type 'dummy'
  state 'down'
  netns 'vpn'
end

ip_link 'nsmtu0' do
  action :add
  type 'dummy'
  mtu 1400
  state 'up'
  netns 'space'
end

ip_link 'nsmac0' do
  action :add
  type 'dummy'
  mtu 900
  mac 'aa:bb:cc:00:11:22'
  netns 'space'
end
