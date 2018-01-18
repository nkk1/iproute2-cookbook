require 'mixlib/shellout'

module IPRoute
  class Vlan
    def initialize(dev)
      @dev = dev
    end
  end

  class Link
    def initialize(dev)
      @dev = dev
    end

    def create(type)
      shellout("#{ip} link add dev #{@dev} type #{type}")
    end

    def exist?
      File.read('/proc/net/dev').each_line { |l| return true if l.split[0] == "#{@dev}:" }
      false
    end

    def down
      shellout("#{ip} link set dev #{@dev} down")
    end

    def up
      shellout("#{ip} link set dev #{@dev} up")
    end

    def up?
      state == 'up' ? true : false
    end

    def down?
      state == 'down' ? true : false
    end

    def state
      next_word(link.split, 'state').downcase
    end

    def state=(new_state)
      shellout("#{ip} link set dev #{@dev} #{new_state}")
    end

    def mtu=(new_mtu)
      shellout("#{ip} link set dev #{@dev} mtu #{new_mtu}")
    end

    def mtu
      next_word(link.split, 'mtu').to_i
    end

    private

    def link
      shellout("#{ip} -o link show #{@dev}")
    end

    def ip
      '/sbin/ip'
    end

    def next_word(words, word)
      words[words.index(word) + 1]
    end

    def shellout(cmd)
      run = Mixlib::ShellOut.new(cmd)
      run.run_command
      if run.error? || run.exitstatus != 0
        raise "#{cmd} failed: \n ----- stderr ----- \n #{run.stderr} \n ------ stdout ----- \n #{run.stdout}"
      end
      run.stdout
    end
  end
end
