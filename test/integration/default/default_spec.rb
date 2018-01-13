require 'serverspec'

describe package('iproute') do
  it { should be_installed }
end
