include_recipe 'iproute2'

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

include_recipe 'iproute2_test::netns' if shell_out('/sbin/ip netns').exitstatus == 0
