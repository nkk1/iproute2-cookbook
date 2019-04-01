
pkg_name = node['platform_family'] == 'suse' ? 'iproute2' : 'iproute'
pkg_name = 'iproute2' if node['platform_version'].to_f == 18.04

package pkg_name do
  action :nothing
end.run_action(:install)
