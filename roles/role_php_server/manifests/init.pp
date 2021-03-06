class role_php_server(
  $version                  	     = 'latest',
  $php_package              	     = 'php',
  $php_package_devel        	     = undef,
  $pear_package             	     = 'php-pear',
  $php_fpm_package          	     = 'php-fpm',
  $php_fpm_service          	     = 'php-fpm',
  $module_prefix            	     = 'php-',
  $fpm_config_file_template 	     = 'role_php_server/app/php/php-fpm.conf.erb',
  $php_ini_file_source      	     = 'puppet:///modules/role_php_server/app/php/php.ini',
  $www_pool                          = 'nginx',
  $modules                  	     = {},
  $pecl_modules             	     = {},
  $module_config_source     	     = undef,
) {
  class { 'service_php5_fpm':
    version                  => $version,
    php_package              => $php_package,
    php_package_devel        => $php_package_devel,
    pear_package             => $pear_package,
    php_fpm_package          => $php_fpm_package,
    php_fpm_service          => $php_fpm_service,
    module_prefix            => $module_prefix,
    fpm_config_file_template => $fpm_config_file_template,
    php_ini_file_source      => $php_ini_file_source,
    www_pool                 => $www_pool,
    modules                  => $modules,
    pecl_modules             => $pecl_modules,
    module_config_source     => $module_config_source,
  }
}
