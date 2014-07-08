# == Class: cron::params
#
# The cron configuration settings.
#
# === Variables
#
# [*cron_job_instances*]
#   A Hash that defines cron::job resources
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class cron::params {

  $job_instances                = $::cron_job_instances ? {
    undef   => false,
    default => $::cron_job_instances,
  }

  case $::osfamily {
    'RedHat': {
      if $::operatingsystemmajrelease < 6 {
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
