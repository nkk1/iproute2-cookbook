
pkg_name = node['platform_family'] == 'suse' ? 'iproute2' : 'iproute'

package pkg_name do
  action :nothing
end.run_action(:install)
