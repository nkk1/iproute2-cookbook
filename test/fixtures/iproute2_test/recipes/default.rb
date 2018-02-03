include_recipe 'iproute2'

include_recipe 'iproute2_test::link'
include_recipe 'iproute2_test::vlan'
include_recipe 'iproute2_test::vlan_netns' if shell_out('/sbin/ip netns').exitstatus == 0
include_recipe 'iproute2_test::netns' if shell_out('/sbin/ip netns').exitstatus == 0
