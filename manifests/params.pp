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

  $job_instances                   = $::cron_job_instances ? {
    undef   => false,
    default => $::cron_job_instances,
  }

  case $::osfamily {
    'RedHat': {
      $cron_package_name           = $::operatingsystemrelease ? {
        /5.\d/ => 'vixie-cron',
        /6.\d/ => 'cronie',
      }
      $cron_service_name           = 'crond'
      $cron_service_hasstatus      = true
      $cron_service_hasrestart     = true
      $cron_service_conf           = '/etc/sysconfig/crond'
      $cron_service_conf_template  = 'cron/crond.sysconfig.erb'
      $crond_args                  = ''
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
