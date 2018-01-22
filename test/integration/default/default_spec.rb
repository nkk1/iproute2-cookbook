require 'serverspec'

describe package('iproute') do
  it { should be_installed }
end

if command('/sbin/ip netns').exit_status == 0
  describe command('/sbin/ip netns') do
    its('stdout') { should_not match /dead/ }
    its('stdout') { should match /vpn/ }
    its('stdout') { should match /space/ }
  end

  describe command('/sbin/ip netns exec vpn ip link show vpn0') do
    its('stdout') { should match /state DOWN/ }
  end

  describe command('/sbin/ip netns exec space ip link show vpn1') do
    its('stdout') { should match /mtu 1400/ }
  end
else
  describe interface('dumb0') do
    it { should_not be_up }
  end

  describe file('/sys/class/net/dumb1/mtu') do
    its('content') { should eq "1400\n" }
  end
end
