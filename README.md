# iproute2 Cookbook


[![Build Status](https://travis-ci.org/karthik-altiscale/iproute2-cookbook.svg?branch=master)](http://travis-ci.org/chef-cookbooks/iproute2) [![Cookbook Version](https://img.shields.io/cookbook/v/iproute2.svg)](https://supermarket.chef.io/cookbooks/iproute2)

Provides custom resources for [iproute](http://manpages.ubuntu.com/manpages/trusty/man8/ip.8.html) commands

* ip-netns
* ip-link

#### todo
* ip-address | ip-route | ip-rule | ip-tunnel | ip-xfrm | ip-maddress | ip-addrlabel | ip-l2tp | ip-monitor | ip-mroute(8) | ip-neighbour | ip-ntable | ip-tcp_metrics

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- Fedora
- OpenSUSE

### Chef

- Chef 12.7+


## Recipes

Installs iproute package

## Custom resources

## ip-netns
---

Action :add (default)

```
ip_netns 'vpn' do
  action :add
end
```

Action :delete

```
ip_netns 'vpn' do
  action :delete
end
```

## ip-link
---

#### Ethernet interface

Action :add (default)
**Note* Does :add and then :set

```
ip_link 'dumb0' do
  action :add
  type 'dummy'
  state 'down'
  netns 'vpn'
  mtu 900
  mac 'aa:bb:cc:00:11:22'
  alias_name 'i am alias of nsalias0'
  qlen 12345
end
```

Action :set

```
ip_link 'dumb0' do
  action :set
  state 'down'
  netns 'vpn'
  mtu 900
  mac 'aa:bb:cc:00:11:22'
  alias_name 'i am alias of nsalias0'
  qlen 12345
end
```

#### VLAN
---
Action :add (default)
```
ip_link 'vlan.200' do
  link 'nsvlan0'
  id 200
  type 'vlan'
  netns 'vlanns'
  mtu 1400
  mac 'aa:00:aa:00:aa:00'
  qlen 300
  alias_name 'i am vlan in netns'
end
```

#### VETH PAIR
---

Action :add

Creates a pair of veth interfaces nsveth1 and nsveth2 and assigns them to appropriate netns

```
ip_link 'nsveth1' do
  type 'veth'
  peer 'nsveth2'
  netns 'aside'
  alias_name 'i am one end'
end
```

```
ip_link 'nsveth2' do
  action :set
  type 'veth'
  netns 'zside'
  alias_name 'i am the other end'
end
```



Properties
* type: can be ..... <#todo>
* state: can be up or down, default is *up*
* netns: netns to which link should be in. make sure netns support is there. 
* mtu: mtu
* mac: update mac. :warning: cookbook does not take care of restarting network or link :warning:
* alias_name: update alias name .. (`alias` is a reserved name so using `alias_name`)
* qlen: update qlen
* link: link on which vlan to be created. used with *vlan* type
* id: vlan id. used with *vlan* type
* peer: used with *veth* type 
