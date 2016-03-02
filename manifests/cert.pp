define letsencrypt_client::cert (
  Optional[String] $webroot,
  Optional[String] $domain_name = $title,
  Optional[Array[Hash]] $domains = undef,
  $install_dir = $letsencrypt_client::params::install_dir,
  $server = $letsencrypt_client::params::acme_server,
) {

  include letsencrypt_client

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

  if ! $domains {
    if $webroot and $domain_name {
      $_domains = [{
        webroot => $webroot,
        domain_name => $domain_name,
      }]
    } else {
      fail('The letsencrypt_client::cert class must be given both a webroot and domain_name.')
    }
  } else {
    if $webroot or $domain_name {
      $_domains = concat($domains, {
        webroot => $webroot,
        domain_name => $domain_name,
      })
    } else {
      $_domains = $domains
    }
  }

  $flags = $_domains.map |$item| {
    "--webroot-path ${item[webroot]} -d ${item[domain_name]}"
  }

  $flags_string = join($flags, " ")

  exec { "${webroot}/letsencrypt/${domain_name}":
    command => "letsencrypt certonly --webroot ${flags_string}",
    path => "${install_dir}/bin:/usr/bin",
    unless => "openssl x509 -checkend 2592000 -noout -in /etc/letsencrypt/live/${domain_name}/cert.pem",
    require => Class['letsencrypt_client'],
  }
}
