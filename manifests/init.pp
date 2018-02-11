# Class for Postfix.

class postfix {

  include postfix::config
  include postfix::packages

  file { $postfix::config::mainfile:
    content => template('postfix/main.cf.erb'),
    notify  => Exec['restart postfix'],
  }

  exec { 'restart postfix' :
    path        =>  '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin',
    command     => 'postfix status && postfix stop && postfix start || postfix start',
    user        => 'root',
    refreshonly => true,
  }

}
