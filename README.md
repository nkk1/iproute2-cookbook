# iproute2 Cookbook


[![Build Status](https://travis-ci.org/karthik-altiscale/iproute2-cookbook.svg?branch=master)](http://travis-ci.org/chef-cookbooks/iproute2) [![Cookbook Version](https://img.shields.io/cookbook/v/iproute2.svg)](https://supermarket.chef.io/cookbooks/iproute2)

Provides custom resources for [iproute](http://manpages.ubuntu.com/manpages/trusty/man8/ip.8.html) commands
* ip-netns
* ip-link

#### todo
* ip-address
* ip-route
* ip-rule
* ip-tunnel
* ip-xfrm

* ip-maddress
* ip-addrlabel
* ip-l2tp
* ip-monitor
* ip-mroute(8)
* ip-neighbour
* ip-ntable
* ip-tcp_metrics

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- Fedora
- OpenSUSE

### Chef

- Chef 12.7+


## Recipes

Installs iproute package

## custom resources

### ip-netns

#### Add netns 

```
ip_netns 'vpn'
```

or
```
ip_netns 'vpn' do
  action :add
end
```


### ip-link

#### Add a new link

```
ip_link 'dumb0' do
  action [:add, :set]
  type 'dummy'
  state 'down'
end
```

#TODO: Add the allowed types

#### turn up the link and set MTU to say 1400

```
ip_link 'dumb1' do
  action :set
  mtu 1400
  state 'up'
end
```

#### Associate the link to netns say vpn and turn up and set MTU to 1400

create vpn netns

```
ip_netns 'vpn'
```

add link to the netns
```
ip_link 'dumb2' do
  action :set
  mtu 1400
  state 'up'
  netns 'vpn
end
```
