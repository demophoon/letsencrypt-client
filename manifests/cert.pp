define letsencrypt_client::cert (
  String $webroot,
  String $domain_name = $title,
) {

  include letsencrypt_client

  $install_dir = $letsencrypt_client::params::install_dir
  $server = $letsencrypt_client::params::acme_server

  # This does not currently work for the certonly method of domain validation.
  # Certificates and private keys by default live in
  # /etc/letsencrypt/live/${domain_name}/
  #
  #$options_hash = {
  #  'cert_path' => "/etc/letsencrypt/live/${domain_name}/cert.crt",
  #  'key_path' => "/etc/letsencrypt/live/${domain_name}/key.pki",
  #  'fullchain_path' => "/etc/letsencrypt/live/${domain_name}/fullchain.crt",
  #  'chain_path' => "/etc/letsencrypt/live/${domain_name}/chain.crt",
  #}
  #$_formatted_hash = prefix($options_hash, '--')
  #$_options = join_keys_to_values($_formatted_hash, '=')
  #$flags = join($_options, ' ')

  exec { "${webroot}/letsencrypt/${domain_name}":
    command => "letsencrypt certonly --webroot --webroot-path ${webroot} -d ${domain_name}",
    path => "${install_dir}/bin:/usr/bin",
    unless => "openssl x509 -checkend 2592000 -noout -in /etc/letsencrypt/live/${domain_name}/cert.pem",
    require => Class['letsencrypt_client'],
  }
}
