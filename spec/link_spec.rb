require 'spec_helper'

ip_link = {
  'lo' => '1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1\    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00',
  'eth' => '36: eth0@if37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default \    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0',
  'eth_old' => '4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9212 qdisc mq state UP qlen 1000\    link/ether 90:e2:ba:5d:a7:10 brd ff:ff:ff:ff:ff:ff',
  'eth_down' => '2: eth0: <BROADCAST,MULTICAST> mtu 9000 qdisc mq state DOWN qlen 1000\    link/ether 00:25:90:c0:b6:8a brd ff:ff:ff:ff:ff:ff',
  'vlan' => '7: eth4.205@eth4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP \    link/ether 90:e2:ba:5a:5c:f2 brd ff:ff:ff:ff:ff:ff',
  'vlan_new' => '8: eth0.222@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000\    link/ether 0c:c4:7a:bb:33:74 brd ff:ff:ff:ff:ff:ff',
}

describe 'interface state' do
  let(:shellout) { double('shellout') }

  before do
    allow(File).to receive(:read).and_return("eth0:\n")
    allow(shellout).to receive(:run_command)
    allow(shellout).to receive(:error?)
    allow(shellout).to receive(:exitstatus).and_return(0)
  end

  context 'good interface' do
    let(:link) { IPRoute::Link.new('eth0') }
    before do
      cmd = '/sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth'])
      link = IPRoute::Link.new('eth0')
      expect(link.state).to eq('up')
    end

    it 'returns interface state' do
      expect(link.state).to eq('up')
    end

    it 'returns true if up' do
      expect(link.up?).to be_truthy
    end

    it 'return false if up' do
      expect(link.down?).to be_falsey
    end

    it 'returns interface mtu' do
      expect(link.mtu).to eq(1500)
    end

    it 'returns if interface exists' do
      expect(link.exist?).to be_truthy
    end
  end
end
