require 'serverspec'

describe package('iproute') do
  it { should be_installed }
end

describe interface('dumb0') do
  it { should_not be_up }
end

describe file('/sys/class/net/dumb1/mtu') do
  its('content') { should eq "1400\n" }
end
