%w(mac0 alias0).each do |nic|
  ip_link nic do
    action :add
    type 'dummy'
  end
end

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
  # double add and set test
  action :add
  type 'dummy'
  mtu 9001
  mac 'aa:bb:cc:00:11:22'
end

ip_link 'alias0' do
  alias_name 'i am alias of alias0'
end

ip_link 'alias0' do
  qlen 12345
end

ip_link 'deltest' do
  type 'dummy'
  state 'up'
end

ip_link 'deltest' do
  action :delete
  type 'dummy'
  state 'down'
end
