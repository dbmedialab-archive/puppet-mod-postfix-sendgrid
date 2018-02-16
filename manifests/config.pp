# Config class for Postfix.

class postfix::config (
  $username,
  $password,
  $myorigin = '$mydomain',
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
    content => "[smtp.sendgrid.net]:2525 ${username}:${password}",
    mode    => '0600',
    notify  => Exec['postmap_sasl_config'],
  }

  exec { 'postmap_sasl_config':
    command => 'postmap /etc/postfix/sasl_passwd',
    unless  => "postmap -s /etc/postfix/sasl_passwd | grep -P \"\[smtp.sendgrid.net\]:2525[[:space:]]\" | grep -q ${username}:${password}",
    path    => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin',
    require => File[$mainfile],
  }

  file { '/etc/postfix/sasl_passwd.db':
    content => '-',
    mode    => '0600',
    replace => 'no',
    require => Exec['postmap_sasl_config'],
  }

}
