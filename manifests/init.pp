# Class: letsencrypt_client
# ===========================
#
# This class configures the letsencrypt cli tool on a node.
#
# Examples
# --------
#
# @example
#    letsencrypt_client::cert { 'www.example.com':
#      webroot => '/path/to/public/root',
#    }
#
# Authors
# -------
#
# Britt Gresham <britt@brittg.com>
#
# Copyright
# ---------
#
# Copyright 2015 Britt Gresham
#
class letsencrypt_client inherits letsencrypt_client::params {

  $install_dir = $letsencrypt_client::params::install_dir

  $pip_packages = [
    'letsencrypt',
  ]

  class { 'python' :
    version    => 'system',
    pip        => 'present',
    virtualenv => 'present',
  }

  python::virtualenv { $install_dir:
    ensure => present,
    require => Class['python'],
  }

  python::pip { $pip_packages:
    ensure => latest,
    virtualenv => $install_dir,
    require => Python::Virtualenv[$install_dir],
  }

}
