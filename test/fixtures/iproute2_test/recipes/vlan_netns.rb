ip_netns 'vlanns'

ip_link 'nsvlan0' do
  type 'dummy'
  state 'up'
end

ip_link 'nsvlantest' do
  link 'nsvlan0'
  type 'vlan'
  netns 'vlanns'
  id 400
  mtu 1400
  mac 'aa:00:aa:00:aa:00'
  qlen 300
  state 'up'
  alias_name 'i am vlan in netns'
end

ip_link 'nsvlandel0' do
  type 'dummy'
  state 'up'
end

ip_link 'nsvlan.del0' do
  link 'nsvlandel0'
  type 'vlan'
  state 'up'
  id 200
  netns 'vlanns'
  alias_name 'i should NOT exist in netns'
end

ip_link 'nsvlan.del0' do
  action :delete
  netns 'vlanns'
  state 'down'
end

ip_link 'nsvlan.del0' do
  action :add
  netns 'vlanns'
  link 'nsvlandel0'
  type 'vlan'
  state 'up'
  id 200
  alias_name 'i should exist in netns'
end
