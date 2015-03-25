class puppet-agent (
  $puppetmaster = undef,
  $runmode
) {

  class {'::puppet':
    server       => false,
    agent        => true,
    version      => 'latest',
    puppetmaster => $puppetmaster,
    runmode      => $runmode
  }

}
