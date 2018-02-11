include_recipe 'iproute2'

include_recipe 'iproute2_test::link'
include_recipe 'iproute2_test::vlan'
include_recipe 'iproute2_test::veth'
include_recipe 'iproute2_test::addr'

if shell_out('/sbin/ip netns').exitstatus == 0
  include_recipe 'iproute2_test::netns'
  include_recipe 'iproute2_test::vlan_netns'
  include_recipe 'iproute2_test::veth_netns'
  include_recipe 'iproute2_test::addr_netns'
end
