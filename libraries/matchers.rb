if defined?(ChefSpec)
  def add_ip_netns(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_netns, :add, resource_name)
  end

  def delete_ip_netns(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_netns, :delete, resource_name)
  end

  def add_ip_link(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_link, :add, resource_name)
  end

  def down_ip_link(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_link, :down, resource_name)
  end

  def delete_ip_link(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_link, :delete, resource_name)
  end

  def add_ip_addr(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_addr, :add, resource_name)
  end

  def delete_ip_addr(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_addr, :delete, resource_name)
  end

  def flush_ip_addr(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_addr, :flush, resource_name)
  end

  def flush_and_set_ip_addr(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ip_addr, :flush_and_set, resource_name)
  end
end
