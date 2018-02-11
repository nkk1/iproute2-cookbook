require 'spec_helper'

describe 'interface state' do
  let(:shellout) { double('shellout') }

  before do
    allow(shellout).to receive(:run_command)
    allow(shellout).to receive(:error?)
    allow(shellout).to receive(:exitstatus).and_return(0)
    allow(shellout).to receive(:stdout)
  end

  context 'when not in netns' do
    let(:addr) { IPRoute::Address.new('lo', 'mockip') }
    before do
      cmd = '/sbin/ip -o -d addr show lo'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(IPRoute.testcases['addr']['lo'])
    end

    it 'returns ips array' do
      expect(addr.ips).to eq(['127.0.0.1/8', '38.8.20.129/32'])
    end

    it 'flushes addresses' do
      expect(Mixlib::ShellOut).to receive(:new)
        .with('/sbin/ip addr flush dev lo').and_return(shellout)
      addr.flush
    end

    it 'adds address' do
      expect(Mixlib::ShellOut).to receive(:new)
        .with('/sbin/ip addr add dev lo mockip').and_return(shellout)
      addr.add
    end

    it 'deletes address' do
      expect(Mixlib::ShellOut).to receive(:new)
        .with('/sbin/ip addr del dev lo mockip').and_return(shellout)
      addr.delete
    end

    it 'returns false if ip doesnt exists' do
      expect(addr.exist?).to be_falsy
    end

    it 'retuns true if exists' do
      addr = IPRoute::Address.new('lo', '127.0.0.1/8')
      expect(addr.exist?).to be_truthy
    end
  end

  context 'when in netns' do
    let(:addr) { IPRoute::Address.new('lo', 'mockip', 'mockns') }
    before do
      cmd = '/sbin/ip netns exec mockns /sbin/ip -o -d addr show lo'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(IPRoute.testcases['addr']['lo'])
    end

    it 'returns ips array' do
      expect(addr.ips).to eq(['127.0.0.1/8', '38.8.20.129/32'])
    end

    it 'flushes addresses' do
      expect(Mixlib::ShellOut).to receive(:new)
        .with('/sbin/ip netns exec mockns /sbin/ip addr flush dev lo').and_return(shellout)
      addr.flush
    end

    it 'adds address' do
      expect(Mixlib::ShellOut).to receive(:new)
        .with('/sbin/ip netns exec mockns /sbin/ip addr add dev lo mockip').and_return(shellout)
      addr.add
    end

    it 'deletes address' do
      expect(Mixlib::ShellOut).to receive(:new)
        .with('/sbin/ip netns exec mockns /sbin/ip addr del dev lo mockip').and_return(shellout)
      addr.delete
    end
  end
end
