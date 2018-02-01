require 'spec_helper'

describe 'interface state' do
  let(:shellout) { double('shellout') }

  before do
    allow(shellout).to receive(:run_command)
    allow(shellout).to receive(:error?)
    allow(shellout).to receive(:exitstatus).and_return(0)
  end

  context 'when no network namespace' do
    describe 'when normal interface' do
      let(:link) { IPRoute::Link.new('eth0') }
      before do
        cmd = '/sbin/ip -o -d link show eth0'
        allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return(IPRoute.testcases['eth'])
      end

      it 'returns interface state' do
        expect(link.state).to eq('up')
      end

      it 'sets interface state' do
        expect(Mixlib::ShellOut).to receive(:new).with('/sbin/ip link set dev eth0 up')
                                                 .and_return(shellout)
        link.state = 'up'
      end

      it 'returns true if state is up' do
        expect(link.up?).to be_truthy
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

      it 'sets interface mtu' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('/sbin/ip link set dev eth0 mtu 987654321').and_return(shellout)
        link.mtu = 987654321
      end

      it 'returns qlen' do
        expect(link.qlen).to eq(1000)
      end

      it 'sets qlen' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('/sbin/ip link set dev eth0 txqueuelen 123456789').and_return(shellout)
        link.qlen = 123456789
      end

      it 'gets mac' do
        expect(link.mac).to eq('0c:c4:7a:90:d3:38')
      end

      it 'sets mac' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('/sbin/ip link set dev eth0 address a:b:c:d:e:f').and_return(shellout)
        link.mac = 'a:b:c:d:e:f'
      end
    end

    describe 'link existance' do
      let(:link) { IPRoute::Link.new('eth4') }
      before(:each) do
        cmd = '/sbin/ip -o link'
        allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return(IPRoute.testcases['eth_down'])
      end

      it 'returns if exists in root namespace' do
        expect(link.exist?).to be_truthy
      end

      # namespace is empty == root
      it 'returns true with exist_in_netns' do
        expect(link.exist_in_netns?).to be_truthy
      end
    end

    describe 'link down' do
      let(:link) { IPRoute::Link.new('eth4') }
      before(:each) do
        cmd = '/sbin/ip -o -d link show eth4'
        allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return(IPRoute.testcases['eth_down'])
      end

      it 'returns down state' do
        expect(link.state).to eq('down')
      end

      it 'returns true if down?' do
        expect(link.down?).to be_truthy
      end
    end

    describe 'link alias' do
      let(:link) { IPRoute::Link.new('eth0') }
      before(:each) do
        cmd = '/sbin/ip  -d link show eth0'
        allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
        allow(shellout).to receive(:stdout).and_return(IPRoute.testcases['alias'])
      end

      it 'returns alias' do
        expect(link.alias).to eq('i am what i am')
      end

      it 'sets alias' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('/sbin/ip link set dev eth0 alias "summa"').and_return(shellout)
        link.alias = 'summa'
      end
    end
  end
end
