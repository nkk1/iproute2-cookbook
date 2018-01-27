require 'spec_helper'

ip_link = {
  'lo' => '1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1\    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00',
  'eth' => '36: eth0@if37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default \    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0',
  'eth_old' => '4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9212 qdisc mq state UP qlen 1000\    link/ether 90:e2:ba:5d:a7:10 brd ff:ff:ff:ff:ff:ff',
  'eth_down' => '2: eth0: <BROADCAST,MULTICAST> mtu 9000 qdisc mq state DOWN qlen 1000\    link/ether 00:25:90:c0:b6:8a brd ff:ff:ff:ff:ff:ff',
  'vlan' => '8: eth0.222@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000\    link/ether 0c:c4:7a:bb:33:74 brd ff:ff:ff:ff:ff:ff',
  'vlan_down' => '11: dumb0.8@dumb0: <BROADCAST,NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000\    link/ether 6e:d9:f0:b8:00:59 brd ff:ff:ff:ff:ff:ff',
  'gre' => '12: tungre0@NONE: <POINTOPOINT,NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT qlen 1\    link/gre 10.1.1.2 peer 10.1.1.1',
  'vti' => '13: vti0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1332 qdisc noqueue state UNKNOWN mode DEFAULT qlen 1\    link/ipip 10.1.1.2 peer 10.1.1.1',
  'ipip' => '14: tunipip0@NONE: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT qlen 1\    link/ipip 10.1.1.2 peer 10.1.1.1',
  'alias' => "5: alias0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 12345\nlink/ether ee:18:1f:52:9a:94 brd ff:ff:ff:ff:ff:ff\nalias i am alias of alias0",
}

describe 'interface state' do
  let(:shellout) { double('shellout') }

  before do
    allow(shellout).to receive(:run_command)
    allow(shellout).to receive(:error?)
    allow(shellout).to receive(:exitstatus).and_return(0)
  end

  context 'when no network namespace' do
    let(:link) { IPRoute::Link.new('eth0') }
    before do
      cmd = ' /sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth'])
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

    it 'returns qlen' do
      cmd = ' /sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth_down'])
      expect(link.qlen).to eq(1000)
    end

    it 'returns alias' do
      cmd = ' /sbin/ip  link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['alias'])
      expect(link.alias).to eq('i am alias of alias0')
    end

    it 'returns down interface' do
      cmd = ' /sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth_down'])
      expect(link.state).to eq('down')
      expect(link.down?).to be_truthy
    end

    it 'returns existence in root netns' do
      cmd = '/sbin/ip -o link'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link.values.join("\n"))
      expect(link.exist?).to be_truthy
    end

    it 'returns existencce in any netns' do
      cmd = ' /sbin/ip -o link'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link.values.join("\n"))
      expect(link.exist_in_netns?).to be_truthy
    end
  end

  context 'when network namespace' do
    let(:link) { IPRoute::Link.new('eth0', 'vpn') }
    before do
      cmd = 'ip netns exec vpn /sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth'])
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

    it 'returns qlen' do
      cmd = 'ip netns exec vpn /sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth_down'])
      expect(link.qlen).to eq(1000)
    end

    it 'returns down interface' do
      cmd = 'ip netns exec vpn /sbin/ip -o link show eth0'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link['eth_down'])
      expect(link.state).to eq('down')
      expect(link.down?).to be_truthy
    end

    it 'returns existence in root netns' do
      cmd = '/sbin/ip -o link'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link.values.join("\n"))
      expect(link.exist?).to be_truthy
    end

    it 'returns existencce in any netns' do
      cmd = 'ip netns exec vpn /sbin/ip -o link'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(ip_link.values.join("\n"))
      expect(link.exist_in_netns?).to be_truthy
    end
  end
end
