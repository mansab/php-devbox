class ssh(
  $server_options,
  $client_options,
  $allowed_host = "0.0.0.0/0"
) {

  firewall { '010 allow ssh access':
    port   => 22,
    proto  => tcp,
    source => $allowed_host,
    action => accept,
  }

  class {'::ssh::client':
    options => $client_options
  }

  class {'::ssh::server':
    options => $server_options
  }

}

