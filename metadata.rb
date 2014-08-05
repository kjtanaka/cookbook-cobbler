name             'cobbler'
maintainer       'FutureGrid'
maintainer_email 'kj.tanaka@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures cobbler'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "yum-epel"
depends "iptables"
depends "selinux"
