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
    before do
      allow(Mixlib::ShellOut).to receive(:new).with('/sbin/ip route show to 1.1.1.0/24')
                                              .and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(
        '12.12.12.0/24 via 172.18.0.3 dev eth0 scope link src 12.12.12.12  metric 2 realm 145  mtu lock 1500 window 1024 rtt 12s'
      )
    end

    let(:route) { IPRoute::Route.new('1.1.1.0/24') }

    describe 'ip route in action' do
      it 'creates route' do
        expect(Mixlib::ShellOut).to receive(:new).with('/sbin/ip route add 1.1.1.0/24')
                                                 .and_return(shellout)
        route = IPRoute::Route.new('1.1.1.0/24')
        route.add
      end

      it 'creates route with options' do
        route = IPRoute::Route.new('1.1.1.0/24', nil, 'dev' => 'eth0',
                                                      'metric' => 1234,
                                                      'table' => 122,
                                                      'src' => '1.1.1.1',
                                                      'realm' => 432,
                                                      'window' => 1024,
                                                      'rtt' => '12s',
                                                      'via' => '8.8.8.8',
                                                      'scope' => 'link')
        expect(Mixlib::ShellOut).to receive(:new).with(
          '/sbin/ip route add 1.1.1.0/24 dev eth0 metric 1234 table 122 src 1.1.1.1 realm 432 window 1024 rtt 12s via 8.8.8.8 scope link'
        ).and_return(shellout)
        route.add
      end

      it 'creates route with options' do
        route = IPRoute::Route.new('1.1.1.0/24', nil, 'dev' => 'eth0',
                                                      'metric' => 1234,
                                                      'table' => 122,
                                                      'src' => '1.1.1.1',
                                                      'realm' => 432,
                                                      'window' => 1024,
                                                      'rtt' => '12s',
                                                      'via' => '8.8.8.8',
                                                      'scope' => 'link')
        expect(Mixlib::ShellOut).to receive(:new).with(
          '/sbin/ip route replace 1.1.1.0/24 dev eth0 metric 1234 table 122 src 1.1.1.1 realm 432 window 1024 rtt 12s via 8.8.8.8 scope link'
        ).and_return(shellout)
        route.replace
      end

      it 'deletes route with options' do
        route = IPRoute::Route.new('1.1.1.0/24', nil, 'dev' => 'eth0',
                                                      'metric' => 1234,
                                                      'table' => 122,
                                                      'src' => '1.1.1.1',
                                                      'realm' => 432,
                                                      'window' => 1024,
                                                      'rtt' => '12s',
                                                      'via' => '8.8.8.8',
                                                      'scope' => 'link')
        expect(Mixlib::ShellOut).to receive(:new).with(
          '/sbin/ip route del 1.1.1.0/24 dev eth0 metric 1234 table 122 src 1.1.1.1 realm 432 window 1024 rtt 12s via 8.8.8.8 scope link'
        ).and_return(shellout)
        route.delete
      end

      it 'flushes route with options' do
        route = IPRoute::Route.new('1.1.1.0/24', nil, 'dev' => 'eth0',
                                                      'metric' => 1234,
                                                      'table' => 122,
                                                      'src' => '1.1.1.1',
                                                      'realm' => 432,
                                                      'window' => 1024,
                                                      'rtt' => '12s',
                                                      'via' => '8.8.8.8',
                                                      'scope' => 'link')
        expect(Mixlib::ShellOut).to receive(:new).with(
          '/sbin/ip route flush 1.1.1.0/24'
        ).and_return(shellout)
        route.flush
      end
    end

    describe 'ip route' do
      it 'returns true existence when dest is cache' do
        route = IPRoute::Route.new('cache', 'non-sense', 'abs-non-sens')
        expect(route.exist_in_netns?).to be_truthy
      end

      it 'returns false if route does not exist' do
        allow(shellout).to receive(:stdout).and_return('')
        expect(route.exist_in_netns?).to be_falsey
      end

      it 'returns true if route exist' do
        expect(route.exist_in_netns?).to be_truthy
      end

      it 'returns via' do
        expect(route.via).to eq('172.18.0.3')
      end

      it 'returns nil when no via' do
        allow(shellout).to receive(:stdout).and_return('12.12.12.0/24 dev eth0')
        expect(route.via).to be_nil
      end

      it 'returns dev' do
        expect(route.dev).to eq('eth0')
      end

      it 'returns nil if no dev' do
        allow(shellout).to receive(:stdout).and_return('12.12.12.0/24 via 12.1.1.2')
        expect(route.dev).to be_nil
      end

      it 'returns window size' do
        expect(route.window).to eq(1024)
      end

      it 'returns rtt' do
        expect(route.rtt).to eq('12s')
      end

      it 'returns mtu' do
        expect(route.mtu).to eq(1500)
      end

      it 'returns if mtu_lock' do
        expect(route.mtu_lock?).to be_truthy
      end

      it 'returns false if no mtu lock' do
        allow(shellout).to receive(:stdout).and_return('12.12.12.0/24 via 12.1.1.2 mtu 12')
        expect(route.mtu_lock?).to be_falsey
      end

      it 'returns scope' do
        expect(route.scope).to eq('link')
      end

      it 'returns src' do
        expect(route.src).to eq('12.12.12.12')
      end

      it 'returns metric' do
        expect(route.metric).to eq(2)
      end

      it 'returns realm' do
        expect(route.realm).to eq('145')
      end
    end
  end

  context 'when in netns' do
    before do
      allow(Mixlib::ShellOut).to receive(:new).with('/sbin/ip netns exec space /sbin/ip route show to 2.2.2.0/24')
                                              .and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(
        '2.2.2.0/24 via 2.2.2.2 dev eth2 scope link src 22.22.22.22 metric 2 realm 222 mtu lock 2222 window 1024 rtt 22s'
      )
    end

    let(:route) { IPRoute::Route.new('2.2.2.0/24', 'space') }

    describe 'ip route' do
      it 'returns false if route does not exist' do
        allow(shellout).to receive(:stdout).and_return('')
        expect(route.exist_in_netns?).to be_falsey
      end

      it 'returns true if route exist' do
        expect(route.exist_in_netns?).to be_truthy
      end

      it 'returns via' do
        expect(route.via).to eq('2.2.2.2')
      end

      it 'returns nil when no via' do
        allow(shellout).to receive(:stdout).and_return('12.12.12.0/24 dev eth0')
        expect(route.via).to be_nil
      end
    end
  end

  context 'when not using main route table' do
    before do
      allow(Mixlib::ShellOut).to receive(:new).with('/sbin/ip netns exec space /sbin/ip route show to 3.3.3.0/24 table 221')
                                              .and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(
        '3.3.3.0/24 via 3.3.3.3 dev eth3 scope link src 33.33.33.33 metric 3 realm 333 mtu lock 3333 window 1024 rtt 33s'
      )
    end

    let(:route) { IPRoute::Route.new('3.3.3.0/24', 'space', 'table' => '221') }

    describe 'ip route' do
      it 'returns false if route does not exist' do
        allow(shellout).to receive(:stdout).and_return('')
        expect(route.exist_in_netns?).to be_falsey
      end

      it 'returns true if route exist' do
        expect(route.exist_in_netns?).to be_truthy
      end

      it 'returns via' do
        expect(route.via).to eq('3.3.3.3')
      end

      it 'returns nil when no via' do
        allow(shellout).to receive(:stdout).and_return('12.12.12.0/24 dev eth0')
        expect(route.via).to be_nil
      end
    end
  end
end
