describe command('/sbin/ip route show table 221') do
  its('stdout') { should match %r{10.12.12.0/24 via 192.168.33.1 dev routetester1\s+scope link\s+src 192.168.33.1\s+metric 1234 realm 133\s+mtu lock 9001 window 1024} }
end

describe command('/sbin/ip route show 0/0') do
  its('stdout') { should match /default via 192.168.34.1 dev routetester0/ }
end

describe command('/sbin/ip route show 192.168.2.0/24') do
  its('stdout') { should match %r{192.168.2.0/24 via 192.168.34.1 dev routetester0} }
end

if command('/sbin/ip netns').exit_status == 0
  describe command('ip netns exec router ip route show 0/0') do
    its('stdout') { should match /default via 192.168.4.1 dev defroutetester0/ }
  end

  describe command('ip netns exec router ip route show table 221') do
    its('stdout') { should match %r{10.12.12.0/24 via 192.168.3.1 dev routetester10\s+src 192.168.3.1\s+metric 1234 realm 133\s+mtu lock 9001 window 1024} }
  end
end
