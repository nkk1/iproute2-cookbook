#
# Copyright 2017, SAP SE or an SAP affiliate company.
# All rights reserved.
#

require 'alti_chef_helpers/spec_helper'

module IPRoute
  def self.testcases
    {
      'link' => {
        'eth' => '5: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000\    link/ether 0c:c4:7a:90:d3:38 brd ff:ff:ff:ff:ff:ff promiscuity 0 addrgenmode eui64',
        'eth_down' => '6: eth4: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000\    link/ether 0c:c4:7a:90:d3:39 brd ff:ff:ff:ff:ff:ff promiscuity 0 addrgenmode eui64',
        'vlan' => '3: eth0.393@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 5000\    link/ether 0c:c4:7a:ea:46:72 brd ff:ff:ff:ff:ff:ff promiscuity 0 \    vlan protocol 802.1Q id 393 <REORDER_HDR> addrgenmode eui64',
        'gre' => '14: tungre0@NONE: <POINTOPOINT,NOARP> mtu 1476 qdisc noqueue state DOWN mode DEFAULT qlen 1\    link/gre 10.1.1.2 peer 10.1.1.1 promiscuity 0 \    gre remote 10.1.1.1 local 10.1.1.2 ttl inherit addrgenmode eui64',
        'alias' => "126: eth0@if127: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT\n link/ether 02:42:ac:12:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0 promiscuity 0\n veth addrgenmode eui64\n alias i am what i am",
        'veth' => '11: veth1@if10: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000\    link/ether 86:1a:45:4d:23:26 brd ff:ff:ff:ff:ff:ff link-netnsid 1 promiscuity 0 \    veth addrgenmode eui64',
      },
      'addr' => {
        'lo' => "1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever\n1: lo    inet 38.8.20.129/32 scope global lo\       valid_lft forever preferred_lft forever\n1: lo    inet6 ::1/128 scope host \       valid_lft forever preferred_lft forever",
        'eth1' =>  "3: eth1    inet 10.246.3.10/30 scope global eth1\       valid_lft forever preferred_lft forever\n3: eth1    inet6 fe80::ec4:7aff:feea:a005/64 scope link \       valid_lft forever preferred_lft forever",
        'vlan' => "3: eth0.393    inet 10.31.82.4/27 scope global eth0.393\       valid_lft forever preferred_lft forever\n3: eth0.393    inet 10.31.82.5/27 scope global secondary eth0.393\       valid_lft forever preferred_lft forever",
        'veth' => "8: oveth    inet 169.254.0.1/24 scope global oveth\       valid_lft forever preferred_lft forever\n8: oveth    inet 169.254.0.2/24 scope global secondary oveth\       valid_lft forever preferred_lft forever\n8: oveth    inet 169.254.0.3/24 scope global secondary oveth\       valid_lft forever preferred_lft forever\n8: oveth    inet 169.254.0.4/24 scope global secondary oveth\       valid_lft forever preferred_lft forever",
      },
    }
  end
end
