ip_link 'dumb0' do
  action :add
  type 'dummy'
  state 'down'
end

ip_link 'dumb1' do
  action :add
  type 'dummy'
  mtu 1400
  state 'up'
end

ip_link 'mac0' do
  action :add
  type 'dummy'
  mtu 9001
  mac 'aa:bb:cc:00:11:22' 
end
