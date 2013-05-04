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
  $crond_args     = '',
  $job_instances  = $cron::params::job_instances
) {

  include cron::params

  $crond_package = $cron::params::crond_package
  $crond_service = $cron::params::crond_service

  package { $crond_package:
    ensure  => installed,
  }

  service { 'crond':
    ensure      => running,
    enable      => true,
    name        => $crond_service,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package[$crond_package],
  }

  file { '/etc/sysconfig/crond':
    ensure    => present,
    content   => template('cron/crond.sysconfig.erb'),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    require   => Package[$crond_package],
    notify    => Service['crond'],
  }

  if $job_instances {
    validate_hash($job_instances)
    create_resources('cron::job', $job_instances)
  }

}
