# == Class: cron
#
# Full description of class cron here.
#
# === Parameters
#
# [*crond_args*]
#   Arguments used by crond at startup.
#   Refer to crond documentation for available options.
#   Default: empty string
#
# [*job_instances*]
#   Hash containing instances passed
#   to cron::job by 'create_resources'
#
# === Examples
#
#  class { 'cron': }
#
#  # Passing instances of cron::job
#  class { 'cron':
#    job_instances => {
#      '/path/to/foo' => {
#         'user'  => 'root',
#         'hour'  => '1',
#      },
#    },
#  }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class cron (
  $crond_args     = $cron::params::crond_args,
  $job_instances  = $cron::params::job_instances
) inherits cron::params {

  if ! defined(Package[$cron::params::cron_package_name]) {
    package { $cron::params::cron_package_name:
      ensure  => installed,
    }
  }

  service { 'crond':
    ensure      => running,
    enable      => true,
    name        => $cron::params::cron_service_name,
    hasstatus   => $cron::params::cron_service_hasstatus,
    hasrestart  => $cron::params::cron_service_hasrestart,
    require     => Package[$cron::params::cron_package_name],
  }

  file { $cron::params::cron_service_conf:
    ensure    => present,
    content   => template($cron::params::cron_service_conf_template),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    require   => Package[$cron::params::cron_package_name],
    notify    => Service['crond'],
  }

  if $job_instances {
    validate_hash($job_instances)
    create_resources('cron::job', $job_instances)
  }

}
