node default {

  stage { 'initialize':
    before => Stage['main'],
  }
 
  stage { 'finalize':
    require => Stage['main'],
  }

  # set explicit allow_virtual to true to avoid warning
  Package {
    allow_virtual => true,
  }

    $assigned_roles = hiera_array('roles', [])

    notify { 'Assigned roles:': }
    notify { $assigned_roles: }

    hiera_include('roles', [])
    
    class { '::epel':
      stage => initialize
    }

    class { "profile::base": 
      stage => finalize
    }

    include service_set_locales

}
