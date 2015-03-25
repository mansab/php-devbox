node default {

  # set explicit allow_virtual to true to avoid warning
  Package {
    allow_virtual => true,
  }

    $assigned_roles = hiera_array('roles', [])

    notify { 'Assigned roles:': }
    notify { $assigned_roles: }

    hiera_include('roles', [])

    class { "base": }

    include service_set_locales
  }
}
