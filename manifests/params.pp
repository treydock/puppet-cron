# == Class: cron::params
#
# The cron configuration settings.
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

  $job_instances          = $::cron_job_instances ? {
    undef   => false,
    default => $::cron_job_instances,
  }

  case $::osfamily {
    'RedHat': {
      $crond_package      = $::operatingsystemrelease ? {
        /5.\d/ => 'vixie-cron',
        /6.\d/ => 'cronie',
      }
      $crond_service      = 'crond'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
