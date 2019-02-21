
ip_netns 'aside'
ip_netns 'zside'

ip_link 'nsveth1' do
  type 'veth'
  peer 'nsveth2'
  netns 'aside'
  alias_name 'i am one end'
end

ip_link 'nsveth2' do
  action :set
  type 'veth'
  netns 'zside'
  alias_name 'i am the other end'
end

ip_link 'nsvethdel1' do
  type 'veth'
  peer 'nsvethdel2'
  netns 'aside'
end

ip_link 'nsvethdel2' do
  action :set
  type 'veth'
  netns 'zside'
end

ip_link 'nsvethdel1' do
  netns 'aside'
  action :delete
end
