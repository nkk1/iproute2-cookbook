ip_link 'veth1' do
  type 'veth'
  peer 'veth2'
  alias_name 'i am one end'
end

ip_link 'veth2' do
  action :set
  type 'veth'
  alias_name 'i am the other end'
end

# TODO: Attach veths to linux bridge
