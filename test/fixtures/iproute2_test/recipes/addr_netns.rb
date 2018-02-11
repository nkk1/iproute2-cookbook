ip_netns 'aside'
ip_netns 'zside'
ip_netns 'addr'

ip_link 'nsaddr0' do
  state 'up'
  type 'dummy'
  netns 'addr'
  ip ['12.1.1.1/8', '1.1.1.1/32', '2.2.2.2/32', '3.3.3.3/31']
end

ip_addr 'lo' do
  netns 'addr'
  ip '5.5.5.5/24'
end

ip_link 'nsaddrvlan0' do
  type 'dummy'
end

ip_link 'nsaddrvlan0.100' do
  action :add
  link 'nsaddrvlan0'
  type 'vlan'
  id 100
  netns 'addr'
  ip '12.12.12.12/24'
end

ip_link 'nsaddrveth1' do
  type 'veth'
  peer 'nsaddrveth2'
  netns 'aside'
  ip Array.new(4) { |i| "169.254.0.#{i + 1}" }
end

ip_link 'nsaddrveth2' do
  type 'veth'
  netns 'zside'
end

ip_addr 'nsaddrveth2' do
  netns 'zside'
  ip Array.new(4) { |i| "169.254.0.#{i + 129}" }
end

# del test
ip_addr 'nsaddr0' do
  netns 'addr'
  action :delete
  ip '2.2.2.2'
end

# flush test
ip_addr 'nsaddrveth2' do
  netns 'zside'
  action :flush
end

# flush and set
ip_addr 'nsaddrveth1' do
  netns 'aside'
  ip '192.168.1.1'
  action :flush_and_set
end
