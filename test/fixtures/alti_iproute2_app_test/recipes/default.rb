include_recipe 'alti_iproute2_app'

include_recipe 'alti_iproute2_app_test::link'
include_recipe 'alti_iproute2_app_test::vlan'
include_recipe 'alti_iproute2_app_test::veth'
include_recipe 'alti_iproute2_app_test::addr'
include_recipe 'alti_iproute2_app_test::route'

if shell_out('/sbin/ip netns').exitstatus == 0
  include_recipe 'alti_iproute2_app_test::netns'
  include_recipe 'alti_iproute2_app_test::vlan_netns'
  include_recipe 'alti_iproute2_app_test::veth_netns'
  include_recipe 'alti_iproute2_app_test::addr_netns'
  include_recipe 'alti_iproute2_app_test::route_netns'
end
