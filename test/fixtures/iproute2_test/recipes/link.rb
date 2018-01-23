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
