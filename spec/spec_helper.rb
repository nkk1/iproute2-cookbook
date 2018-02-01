require 'chefspec'

module IPRoute
  def self.testcases
    {
      'eth' => '5: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000\    link/ether 0c:c4:7a:90:d3:38 brd ff:ff:ff:ff:ff:ff promiscuity 0 addrgenmode eui64',
      'eth_down' => '6: eth4: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000\    link/ether 0c:c4:7a:90:d3:39 brd ff:ff:ff:ff:ff:ff promiscuity 0 addrgenmode eui64',
      'vlan' => '3: eth0.393@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 5000\    link/ether 0c:c4:7a:ea:46:72 brd ff:ff:ff:ff:ff:ff promiscuity 0 \    vlan protocol 802.1Q id 393 <REORDER_HDR> addrgenmode eui64',
      'gre' => '14: tungre0@NONE: <POINTOPOINT,NOARP> mtu 1476 qdisc noqueue state DOWN mode DEFAULT qlen 1\    link/gre 10.1.1.2 peer 10.1.1.1 promiscuity 0 \    gre remote 10.1.1.1 local 10.1.1.2 ttl inherit addrgenmode eui64',
      'alias' => "126: eth0@if127: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT\n link/ether 02:42:ac:12:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0 promiscuity 0\n veth addrgenmode eui64\n alias i am what i am",
    }
  end
end
