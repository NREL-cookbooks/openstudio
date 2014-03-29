name             'openstudio'
maintainer       'NREL'
maintainer_email 'nicholas.long@nrel.gov'
license          'LGPL'
description      'Installs/Configures OpenStudio'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.6'

depends "energyplus"
depends "apt"
depends "ark"
depends "yum"
depends "yum-epel"
depends "build-essential"
depends "gdebi"

depends "rbenv"
depends "ruby_build"
