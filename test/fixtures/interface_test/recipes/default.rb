execute 'dummy nic' do
  command '/sbin/modprobe dummy'
  not_if '/sbin/lsmod | grep dummy'
end
