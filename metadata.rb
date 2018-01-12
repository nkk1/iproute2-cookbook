name              'interface'
maintainer        'karthik'
maintainer_email  'kumarkarthikn@gmail.com'
description       'Provides LWRP to configure interfaces'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.0.1'
license 'All rights reserved'

chef_version '>= 12.5'

source_url "https://github.com/VertiCloud/#{name}-cookbook"
issues_url "#{source_url}/issues"

supports          'centos', '>= 6.0'
supports          'centos', '>= 7.0'
supports          'fedora'
