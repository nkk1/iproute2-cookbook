require 'spec_helper'

describe 'alti_iproute2_app::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '6.9').converge(described_recipe)
  end

  it 'installs iproute' do
    expect(chef_run).to install_package('iproute')
  end
end
