name             'openstudio'
maintainer       'NREL'
maintainer_email 'nicholas.long@nrel.gov'
license          'LGPL'
description      'Installs/Configures OpenStudio'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends "apt"
depends "yum"
depends "yum-epel"
depends "gdebi"
depends "energyplus"
depends "rbenv"
depends "ruby_build"
depends "build-essential"
depends "ark"
