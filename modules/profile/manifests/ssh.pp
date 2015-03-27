class profile::ssh(
  $server_options,
  $client_options,
) {

  class {'::ssh::client':
    options => $client_options
  }

  class {'::ssh::server':
    options => $server_options
  }

}

