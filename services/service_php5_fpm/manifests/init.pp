class service_php5_fpm(
  $version                  = 'latest',
  $php_package              = 'php',
  $php_package_devel        = undef,
  $pear_package             = 'php-pear',
  $php_fpm_package          = 'php-fpm',
  $php_fpm_service          = 'php-fpm',
  $module_prefix            = 'php-',
  $fpm_config_file_template = 'role_php_server/app/php/php-fpm.conf.erb',
  $php_ini_file_source      = 'puppet:///modules/role_php_server/app/php/php.ini',
  $www_pool                 = 'nginx',
  $modules                  = {},
  $pecl_modules             = {},
  $module_config_source     = undef,
) {

  package { "php-fpm":
    name   => $php_fpm_package, 
    ensure => "present",
  }

  service{ "php-fpm":
    name   => $php_fpm_service,
    ensure => running,
    enable => true
  }

  case $operatingsystem {
    CentOS: {
      $pidfile = '/var/run/php-fpm/php-fpm.pid' 
    }
    Ubuntu: {
      $pidfile = '/var/run/php5-fpm.pid'
    }
  }

  file { "/etc/php-fpm.conf":
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => template($fpm_config_file_template),
    notify  => Service[$php_fpm_service],
    require => Package[ [$php_fpm_package, 'nginx'] ] # nginx package is needed due to php-fpm www_pool configuration, user & group definition.
  }

  class { 'php':
    version       => $latest,
    package       => $php_package,
    package_devel => $php_package_devel,
    service       => $php_fpm_service,
    module_prefix => $module_prefix,
    config_file   => "/etc/php/php.ini",
    source        => $php_ini_file_source,
    require       => Package[$php_fpm_package]
  }

  class { 'php::pear':
    package => $pear_package,
    require => Class['php']
  }

  class { 'php::devel':
    require => Class['php']
  }

  file {"/etc/$php_package/":
    ensure => directory
  }

  file {"/etc/$php_package/mods-available/":
    ensure  => directory,
    require => File["/etc/$php_package/"]
  }

  create_resources('php::module', $modules)
  create_resources('php::pecl::module', $pecl_modules)

  $xdebug_cond = defined(Php::Module[pecl-xdebug]) or defined(Php::Module[xdebug])
  file {"/etc/$php_package/mods-available/xdebug.ini":
    ensure => $xdebug_cond ? {
      true => 'present',
      default => 'absent',
    },
    source => $module_config_source,
    notify => Service[$php_fpm_service],
    require => File["/etc/$php_package/mods-available/"]
  }
  file {"/etc/php.d/xdebug.ini":
    ensure => $xdebug_cond ? {
      true => 'present',
      default => 'absent',
    },
    source => $module_config_source,
    notify => Service[$php_fpm_service],
    require => Class["php"]
  }
}
