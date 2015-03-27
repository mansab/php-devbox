class service_set_locales {

  file { 'set_locales':
    path    => "/tmp/locales.sh",
    source  => 'puppet:///modules/service_set_locales/locales.sh',
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '744'
  }

  exec { 'set_locales':
    command => '/tmp/locales.sh',
    unless  => '/usr/bin/printenv LC_ALL',
    path => "/usr/bin/sh",
    require => File ['set_locales']
  }
}