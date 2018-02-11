describe command('/sbin/ip -o -d addr show addr0') do
  its('stdout') { should match %r{addr0\s+inet 12.1.1.1/8} }
end

describe command('/sbin/ip -o -d addr show addr1') do
  its('stdout') { should match %r{addr1\s+inet 1.1.1.1\/28} }
  its('stdout') { should match %r{addr1\s+inet 3.3.3.3\/32} }
  its('stdout') { should match %r{addr1\s+inet 4.4.4.4\/30} }
  its('stdout') { should_not match %r{addr1\s+inet 2.2.2.2\/32} }
end

describe command('/sbin/ip -o -d addr show lo') do
  its('stdout') { should match %r{5.5.5.5\/24} }
end

describe command('/sbin/ip -o -d addr show addrvlan0.100') do
  its('stdout') { should match %r{12.12.12.12\/24} }
end

describe command('/sbin/ip -o -d addr show addrveth1') do
  its('stdout') { should match /169.254.0.1/ }
  its('stdout') { should match /169.254.0.2/ }
  its('stdout') { should match /169.254.0.3/ }
  its('stdout') { should match /169.254.0.4/ }
end

describe command('/sbin/ip -o -d addr show addrveth2') do
  its('stdout') { should match /169.254.0.(129|130|131|132)/ }
  # 133 to 256
  its('stdout') { should_not match /169.254.0.(13[3-9]|1[4-9][0-9]|2[0-4][0-9]|25[0-6])/ }
  # 1 to 128
  # TODO: its('stdout') { should_not match /169.254.0.([1-9]|[1-8][0-9]|9[0-9]|1[01][0-9]|12[0-8])/ }
end

describe command('/sbin/ip -o -d addr show addrdelveth1') do
  its('stdout') { should_not match /169.254.0/ }
  its('stdout') { should match %r{38.39.40.41\/32} }
end

describe command('/sbin/ip -o -d addr show addrdelveth1') do
  its('stdout') { should_not match %r{169.254.0.130\/32} }
end

describe command('/sbin/ip -o -d addr s dev addrflush0') do
  its('stdout') { should match /^$/ }
end

if command('/sbin/ip netns').exit_status == 0
  describe command('/sbin/ip netns exec addr ip addr show nsaddr0') do
    its('stdout') { should match %r{inet 1.1.1.1\/32} }
    its('stdout') { should match %r{inet 12.1.1.1\/8} }
    its('stdout') { should match %r{inet 3.3.3.3\/31} }
    its('stdout') { should_not match %r{inet 2.2.2.2\/32} }
  end

  describe command('/sbin/ip netns exec addr ip addr show lo') do
    its('stdout') { should match %r{5.5.5.5\/24} }
  end

  describe command('/sbin/ip netns exec addr ip addr show nsaddrvlan0.100') do
    its('stdout') { should match %r{12.12.12.12\/24} }
  end

  describe command('/sbin/ip netns exec aside ip addr show nsaddrveth2') do
    its('stdout') { should match /^$/ }
  end

  describe command('/sbin/ip netns exec aside ip addr show nsaddrveth1') do
    its('stdout') { should match %r{192.168.1.1\/32} }
    its('stdout') { should_not match /169.254/ }
  end
end
