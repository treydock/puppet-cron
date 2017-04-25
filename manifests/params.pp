# == Class: cron::params
#
class cron::params {

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemrelease, '6.0') < 0 {
        $package_name           = 'vixie-cron'
      } else {
        $package_name           = 'cronie'
      }
      $service_name             = 'crond'
      $service_hasstatus        = true
      $service_hasrestart       = true
      $service_config_path      = '/etc/sysconfig/crond'
      $service_config_template  = 'cron/crond.sysconfig.erb'
      $crond_args               = ''
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
