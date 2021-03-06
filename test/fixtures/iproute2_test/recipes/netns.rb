ip_netns 'dead'

ip_netns 'dead' do
  action :delete
end

ip_netns 'vpn'
ip_netns 'space'

ip_link 'nsvpn0' do
  action :add
  type 'dummy'
  state 'down'
  netns 'vpn'
end

ip_link 'nsmtu0' do
  action :add
  mtu 1400
  state 'up'
  type 'dummy'
  netns 'space'
end

ip_link 'nsmac0' do
  action :add
  type 'dummy'
  mtu 900
  mac 'aa:bb:cc:00:11:22'
  netns 'space'
end

ip_link 'nsalias0' do
  type 'dummy'
  netns 'vpn'
end

ip_link 'nsalias0' do
  type 'dummy'
  netns 'vpn'
end

ip_link 'nsalias0' do
  netns 'vpn'
  alias_name 'i am alias of nsalias0'
  qlen 12345
end

ip_link 'nsdeltest0' do
  type 'dummy'
  state 'up'
  netns 'vpn'
end

ip_link 'nsdeltest0' do
  type 'dummy'
  netns 'vpn'
  state 'down'
  action :delete
end
