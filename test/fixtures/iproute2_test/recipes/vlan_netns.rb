ip_netns 'vlanns'

ip_link 'nsvlan0' do
  type 'dummy'
end

ip_link 'nsvlantest' do
  link 'nsvlan0'
  type 'vlan'
  netns 'vlanns'
  id 400
  mtu 1400
  mac 'aa:00:aa:00:aa:00'
  qlen 300
  alias_name 'i am vlan in netns'
end
