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
