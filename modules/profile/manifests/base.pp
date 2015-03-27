class profile::base(
  $common_packages = ['tmux', 'curl', 'wget', 'rsync', 'unzip', 'htop'],
  $update_packages = {},
  $puppetmaster    = undef,
  $puppetrunmode   = "none"
){
   class { "profile::ssh":
     server_options => hiera('ssh_server_options'),
     client_options => hiera('ssh_client_options')
   }

   class { "profile::puppet-agent":
     puppetmaster => $puppetmaster,
     runmode      => $puppetrunmode
   }

   ensure_packages($common_packages)
   create_resources('Package', $update_packages, {'ensure' => 'latest'})
}
