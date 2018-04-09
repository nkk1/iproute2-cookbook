ip_netns 'router'

ip_link 'routetester10' do
  type 'dummy'
  netns 'router'
  ip '192.168.3.1/24'
end

ip_route '10.12.12.0/24' do
  netns 'router'
  via '192.168.3.1'
  dev 'routetester10'
  metric 1234
  table 221
  src '192.168.3.1'
  realm  133
  mtu 9001
  mtu_lock true
  window 1024
  rtt '12s'
end

ip_link 'defroutetester0' do
  type 'dummy'
  netns 'router'
  ip '192.168.4.1/24'
end

ip_route '0.0.0.0/0' do
  netns 'router'
  via '192.168.4.1'
  dev 'defroutetester0'
end
