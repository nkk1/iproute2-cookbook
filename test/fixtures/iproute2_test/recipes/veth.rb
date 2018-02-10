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

ip_link 'vethdeltest1' do
  type 'veth'
  state 'up'
  peer 'vethdeltest2'
end

ip_link 'vethdeltest1' do
  type 'veth'
  state 'down'
  action :delete
end

# TODO: Attach veths to linux bridge
