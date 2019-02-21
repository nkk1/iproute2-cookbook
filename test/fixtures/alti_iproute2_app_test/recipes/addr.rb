ip_link 'addr0' do
  state 'up'
  type 'dummy'
  ip '12.1.1.1/8'
end

ip_link 'addr1' do
  state 'up'
  type 'dummy'
  ip ['1.1.1.1/28', '2.2.2.2']
end

ip_addr 'addr1' do
  ip ['3.3.3.3', '4.4.4.4/30']
end

ip_addr 'lo' do
  ip '5.5.5.5/24'
end

ip_link 'addrvlan0' do
  type 'dummy'
end

ip_link 'addrvlan0.100' do
  action :add
  link 'addrvlan0'
  type 'vlan'
  id 100
  ip '12.12.12.12/24'
end

ip_link 'addrveth1' do
  type 'veth'
  peer 'addrveth2'
  ip Array.new(4) { |i| "169.254.0.#{i + 1}" }
end

ip_addr 'addrveth2' do
  ip Array.new(4) { |i| "169.254.0.#{i + 129}" }
end

# del test
ip_addr 'addr1' do
  action :delete
  ip '2.2.2.2'
end

ip_link 'addrdelveth1' do
  type 'veth'
  peer 'addrdelveth2'
  ip Array.new(4) { |i| "169.254.0.#{i + 1}" }
end

ip_addr 'addrdelveth2' do
  ip Array.new(4) { |i| "169.254.0.#{i + 129}" }
end

ip_addr 'addrdelveth2' do
  ip '169.254.0.130/32'
  action :delete
end

# flush and set

ip_addr 'addrdelveth1' do
  ip '38.39.40.41'
  action :flush_and_set
end

# flush
ip_link 'addrflush0' do
  state 'up'
  type 'dummy'
  ip Array.new(16) { |i| "10.0.0.#{i + 1}" }
end

ip_addr 'addrflush0' do
  action :flush
end
