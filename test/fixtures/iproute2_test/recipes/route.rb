ip_link 'routetester0' do
  ip '192.168.34.1'
  type 'dummy'
end

ip_link 'routetester1' do
  ip '192.168.33.1'
  type 'dummy'
end

ip_route '10.12.12.0/24' do
  via '192.168.34.1'
  dev 'routetester0'
  metric 1234
  table 221
  src '192.168.33.1'
  realm 124
  mtu 9001
  mtu_lock true
  window 1024
end

ip_route '10.12.12.0/24' do
  via '192.168.33.1'
  dev 'routetester1'
  metric 1234
  table 221
  src '192.168.33.1'
  realm  133
  mtu 9001
  mtu_lock true
  window 1024
  scope 253
end

ip_route '192.168.2.0/24' do
  via '192.168.34.1'
  dev 'routetester0'
end

ip_route '0.0.0.0/0' do
  via '192.168.34.1'
  dev 'routetester0'
end

ip_route '3.3.3.0/24' do
  via '192.168.34.1'
  dev 'routetester0'
end

ip_route '3.3.3.0/24' do
  via '192.168.34.1'
  dev 'routetester0'
  action :delete
end

ip_route '3.3.3.0/24' do
  via '192.168.34.1'
  dev 'routetester0'
  action :delete
end

ip_route '3.3.3.0/24' do
  via '192.168.34.1'
  dev 'routetester0'
  action :flush
end

ip_route 'cache' do
  action :flush
end
