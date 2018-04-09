name              'iproute2'
maintainer        'karthik'
maintainer_email  'kumarkarthikn@gmail.com'
description       'Provides custom resources for iproute2 commands'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '2.0.0'
license           'Apache-2.0'

chef_version '>= 12.5'

source_url "https://github.com/karthik-altiscale/#{name}-cookbook"
issues_url "#{source_url}/issues"

supports          'ubuntu', '>= 12.04'
supports          'debian', '>= 7.0'
supports          'redhat', '>= 5.0'
supports          'centos', '>= 5.0'
supports          'fedora'
supports          'scientific'
supports          'amazon'
supports          'oracle'
