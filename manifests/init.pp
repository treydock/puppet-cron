# == Class: cron
#
class cron (
  $crond_args               = $cron::params::crond_args,
  $package_name             = $cron::params::package_name,
  $service_ensure           = 'running',
  $service_enable           = true,
  $service_config_path      = $cron::params::service_config_path,
  $service_config_template  = $cron::params::service_config_template,
  $service_name             = $cron::params::service_name,
  $service_hasstatus        = $cron::params::service_hasstatus,
  $service_hasrestart       = $cron::params::service_hasrestart,
  $cron_allow               = [],
  $cron_deny                = [],
) inherits cron::params {

  validate_array($cron_allow)
  validate_array($cron_deny)

  package { 'cron':
    ensure => 'present',
    name   => $package_name,
    before => File['/etc/sysconfig/crond'],
  }

  file { '/etc/sysconfig/crond':
    ensure  => 'present',
    path    => $service_config_path,
    content => template($service_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  service { 'crond':
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => $service_name,
    hasstatus  => $service_hasstatus,
    hasrestart => $service_hasrestart,
    subscribe  => File['/etc/sysconfig/crond'],
  }

  if empty($cron_allow) {
    file { '/etc/cron.allow':
      ensure => 'absent',
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

}
