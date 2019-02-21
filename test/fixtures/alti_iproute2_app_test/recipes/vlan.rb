ip_link 'vlan0' do
  type 'dummy'
end

ip_link 'vlan0.100' do
  action :add
  link 'vlan0'
  type 'vlan'
  id 100
  mtu 1200
  mac '00:aa:00:aa:00:aa'
  qlen 200
  alias_name 'i am a test vlan'
end

ip_link 'vlandel0' do
  type 'dummy'
  state 'up'
end

ip_link 'vlan.del0' do
  link 'vlandel0'
  type 'vlan'
  state 'up'
  id 200
  alias_name 'i should NOT exist'
end

ip_link 'vlan.del0' do
  action :delete
  state 'down'
end

ip_link 'vlan.del0' do
  action :add
  link 'vlandel0'
  type 'vlan'
  state 'up'
  id 200
  alias_name 'i should exist'
end
