module IPRoute
  class Route
    def initialize(dest, netns = nil, route_params = {})
      @dest = dest
      @netns = netns
      @route_params = route_params
    end

    def add
      create('add')
    end

    def replace
      create('replace')
    end

    def create(action)
      cmd = ["#{netns_exec}#{ip} route #{action} #{@dest}"]

      %w(dev metric table src realm window rtt via scope).each do |param|
        cmd << ["#{param} #{@route_params[param]}"] if @route_params[param]
      end

      cmd << ["mtu #{'lock' if @route_params['mtu_lock']} #{@route_params['mtu']}"] if @route_params['mtu']

      shellout(cmd.join(' '))
    end

    def exist_in_netns?
      !route.empty?
    end

    def via
      next_word('via')
    end

    def dev
      next_word('dev')
    end

    def scope
      next_word('scope')
    end

    def src
      next_word('src')
    end

    def metric
      metric_str = next_word('metric')
      metric_str.to_i if metric_str
    end

    def realm
      next_word('realm')
    end

    def mtu_lock?
      next_word('mtu') == 'lock'
    end

    def mtu
      mtu_next = next_word('mtu')
      return next_word('lock').to_i if mtu_next == 'lock'
      mtu_next.to_i if mtu_next
    end

    def window
      window_next = next_word('window')
      window_next.to_i if window_next
    end

    def rtt
      next_word('rtt')
    end

    private

    def next_word(word)
      words = route.split
      return nil unless words.index(word)
      words[words.index(word) + 1]
    end

    def route
      to = @dest ? " to #{@dest}" : ''
      table = @route_params['table'] ? " table #{@route_params['table']}" : ''
      shellout("#{netns_exec}#{ip} route show#{to}#{table}")
    end

    def netns_exec
      @netns ? "#{ip} netns exec #{@netns} " : ''
    end

    def shellout(cmd)
      IPRoute::Utils.shellout(cmd)
    end

    def ip
      '/sbin/ip'
    end
  end
end
