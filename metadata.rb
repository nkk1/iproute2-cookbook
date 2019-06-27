name              'alti_iproute2_app'
maintainer        'karthik'
maintainer_email  'kumarkarthikn@gmail.com'
description       'Provides custom resources for iproute2 commands'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
license           'Apache-2.0'

JSON.parse(File.read(File.join(File.dirname(__FILE__), 'depends.json'))).each_pair do |cbk,ver|
  depends cbk,ver
end
source_url "https://github.com/VertiCloud/#{name}-cookbook"
issues_url "#{source_url}/issues"
chef_version '>= 12.5'

supports 'prometheus'
