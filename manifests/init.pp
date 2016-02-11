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

  # TODO: Make this work across OS
  $required_dev_packages = ['libffi-dev', 'libssl-dev']

  package { $required_dev_packages:
    ensure => present
  }

  class { 'python':
    version    => 'system',
    dev        => 'present',
    pip        => 'present',
    virtualenv => 'present',
    require    => Package[$required_dev_packages]
  }

  python::virtualenv { $install_dir:
    ensure  => present,
    require => Class['python'],
  }

  python::pip { $pip_packages:
    ensure     => latest,
    virtualenv => $install_dir,
    require    => Python::Virtualenv[$install_dir],
  }

}
