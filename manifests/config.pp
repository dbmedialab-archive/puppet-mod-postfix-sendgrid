# Config class for Postfix.

class postfix::config (
  $username,
  $password,
) {

  $mainfile = '/etc/postfix/main.cf'

  # Send mail via Sendgrid. See the documentation at
  # https://sendgrid.com/docs/Integrate/Mail_Servers/postfix.html
  # for further information.

  $smtp_sasl_auth_enable = 'yes'
  $smtp_sasl_password_maps = "hash:/etc/postfix/sasl_passwd"
  $smtp_sasl_security_options = 'noanonymous'
  $smtp_tls_security_level = 'encrypt'
  $header_size_limit = 4096000
  $relayhost = '[smtp.sendgrid.net]:2525'

  file { '/etc/postfix/sasl_passwd':
    mode    => '0600',
    content => "[smtp.sendgrid.net]:2525 ${username}:${password}",
    notify  => Exec['postmap_sasl_config'],
  }

  exec { 'postmap_sasl_config':
    path        => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin',
    command     => 'postmap /etc/postfix/sasl_passwd',
    refreshonly => true,
  }

  file { '/etc/postfix/sasl_passwd.db':
    mode    => '0600',
    content => '-',
    replace => 'no',
    require => Exec['postmap_sasl_config'],
  }

}
