name = os[:family] == 'suse' ? 'iproute2' : 'iproute'

describe package(name) do
  it { should be_installed }
end

if command('/sbin/ip netns').exit_status == 0
  describe command('/sbin/ip netns') do
    its('stdout') { should_not match /dead/ }
    its('stdout') { should match /vpn/ }
    its('stdout') { should match /space/ }
  end

  describe command('/sbin/ip netns exec vpn ip link show nsvpn0') do
    its('stdout') { should match /state DOWN/ }
  end

  describe command('/sbin/ip netns exec space ip link show nsmtu0') do
    its('stdout') { should match /mtu 1400/ }
  end

  describe command('/sbin/ip netns exec space ip link show nsmac0') do
    its('stdout') { should match /aa:bb:cc:00:11:22/ }
  end

  describe command('/sbin/ip netns exec vpn ip link show nsalias0') do
    its('stdout') { should match /alias i am alias of nsalias0/ }
    its('stdout') { should match /qlen 12345/ }
  end

  describe command('/sbin/ip netns exec vpn ip link show nsdeltest0') do
    its('stderr') { should match /Device "nsdeltest0" does not exist/ }
  end

  describe command('/sbin/ip netns exec vlanns ip link show nsvlantest') do
    its('stdout') { should match /mtu 1400/ }
    its('stdout') { should match /ether aa:00:aa:00:aa:00/ }
    its('stdout') { should match /qlen 300/ }
    its('stdout') { should match /alias i am vlan in netns/ }
  end

  describe command('/sbin/ip netns exec vlanns /sbin/ip link show nsvlan.del0') do
    its('stdout') { should match /i should exist in netns/ }
  end

  describe command('/sbin/ip netns exec aside ip link show') do
    its('stdout') { should match /nsveth1@/ }
    its('stdout') { should match /alias i am one end/ }
  end

  describe command('/sbin/ip netns exec zside ip link show') do
    its('stdout') { should match /nsveth2@/ }
    its('stdout') { should match /alias i am the other end/ }
  end
end

describe command('/sbin/ip link show vlan.del0') do
  its('stdout') { should match /i should exist/ }
end

describe interface('vethdeltest1') do
  it { should_not exist }
end

describe interface('vethdeltest2') do
  it { should_not exist }
end

describe interface('deltest') do
  it { should_not exist }
end

describe interface('nsvpn0') do
  it { should_not exist }
end

describe interface('nsmac0') do
  it { should_not exist }
end

describe interface('nsalias0') do
  it { should_not exist }
end

describe interface('dumb0') do
  it { should_not be_up }
end

describe interface('nsvlantest') do
  it { should_not be_up }
end

describe interface('nsvlan0') do
  it { should_not be_up }
end

describe file('/sys/class/net/dumb1/mtu') do
  its('content') { should eq "1400\n" }
end

describe file('/sys/class/net/mac0/address') do
  its('content') { should eq "aa:bb:cc:00:11:22\n" }
end

describe command('/sbin/ip link show alias0') do
  its('stdout') { should match /alias i am alias of alias0/ }
end

describe command('/sbin/ip link show alias0') do
  its('stdout') { should match /qlen 12345/ }
end

describe command('/sbin/ip link show vlan0.100') do
  its('stdout') { should match /ether 00:aa:00:aa:00:aa/ }
  its('stdout') { should match /mtu 1200/ }
  its('stdout') { should match /qlen 200/ }
  its('stdout') { should match /alias i am a test vlan/ }
end

describe interface('nsveth1') do
  it { should_not exist }
end

describe interface('nsveth2') do
  it { should_not exist }
end

describe interface('veth1') do
  it { should exist }
end

describe interface('veth2') do
  it { should exist }
end
