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
  $crond_args               = $cron::params::crond_args,
  $package_name             = $cron::params::package_name,
  $service_ensure           = 'running',
  $service_enable           = true,
  $service_autorestart      = true,
  $service_config_path      = $cron::params::service_config_path,
  $service_config_template  = $cron::params::service_config_template,
  $service_name             = $cron::params::service_name,
  $service_hasstatus        = $cron::params::service_hasstatus,
  $service_hasrestart       = $cron::params::service_hasrestart,
  $cron_allow               = [],
  $cron_deny                = [],
  $job_instances            = $cron::params::job_instances
) inherits cron::params {

  validate_bool($service_autorestart)
  validate_array($cron_allow)
  validate_array($cron_deny)

  # This gives the option to not manage the service 'ensure' state.
  $service_ensure_real  = $service_ensure ? {
    /UNSET|undef/ => undef,
    default       => $service_ensure,
  }

  # This gives the option to not manage the service 'enable' state.
  $service_enable_real  = $service_enable ? {
    /UNSET|undef/ => undef,
    default       => $service_enable,
  }

  $service_subscribe = $service_autorestart ? {
    true  => File['/etc/sysconfig/crond'],
    false => undef,
  }

  package { 'cron':
    ensure  => present,
    name    => $package_name,
    before  => File['/etc/sysconfig/crond'],
  }

  service { 'crond':
    ensure      => $service_ensure,
    enable      => $service_enable,
    name        => $service_name,
    hasstatus   => $service_hasstatus,
    hasrestart  => $service_hasrestart,
    subscribe   => $service_subscribe,
  }

  file { '/etc/sysconfig/crond':
    ensure    => present,
    path      => $service_config_path,
    content   => template($service_config_template),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
  }

  if empty($cron_allow) {
    file { '/etc/cron.allow':
      ensure  => 'absent',
    }
  } else {
    file { '/etc/cron.allow':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template('cron/cron.allow.erb'),
    }
  }

  file { '/etc/cron.deny':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('cron/cron.deny.erb'),
  }

  if $job_instances {
    validate_hash($job_instances)
    create_resources('cron::job', $job_instances)
  }

}
