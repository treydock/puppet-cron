# == Define: cron::job
#
# Wrapper definition for the cron resource type.
#
# === Parameters
#
# [*ensure*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*command*]
#   Defaults to $name if undefined.
#   If command begins with 'run-part', the path following
#   will be created and managed by Puppet
#
#   See Puppetlabs documentation for further usage of *command*
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*user*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*hour*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*minute*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*month*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*monthday*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*weekday*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*special*]
#   See Puppetlabs documentation
#    http://docs.puppetlabs.com/references/sjoble/type.html#cron
#
# [*run_part*]
#   Boolean, that when true will create the directory listed in
#   the command parameter if the command begins with 'run-part'
#   Default: false
#
# === Examples
#
#  cron::job { '/usr/sbin/raid-check':
#    user    => 'root',
#    minute  => '0',
#    hour    => '1',
#    weekday => 'Sun',
#  }
#
#  cron::job { 'logrotate':
#    command => '/usr/sbin/logrotate',
#    user    => 'root',
#    minute  => '*/10',
#  }
#
#  Create directory with scripts to be run using 'run-part'
#  cron::job { 'cron.5min':
#    command    => 'run-part /etc/cron.5min',
#    user       => 'root',
#    minute     => '0,5,10,15,20,25,30,35,40,45,50,55',
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
define cron::job (
  $ensure     = present,
  $command    = $name,
  $user       = undef,
  $hour       = undef,
  $minute     = undef,
  $month      = undef,
  $monthday   = undef,
  $weekday    = undef,
  $special    = undef,
  $run_part   = false
) {

  include cron::params

  if $command =~ /^run-part\s.*/ {
    $run_part_dir   = inline_template('<%= @command[/^run-part\s+(.*)$/, 1] %>')
  }

  cron { $name:
    ensure    => $ensure,
    command   => $command,
    user      => $user,
    minute    => $minute,
    hour      => $hour,
    month     => $month,
    monthday  => $monthday,
    weekday   => $weekday,
    special   => $special,
    require   => Package['cron'],
  }

  if $run_part_dir and $ensure =~ /present/ and $run_part {
    validate_absolute_path($run_part_dir)

    file { $run_part_dir:
      ensure  => directory,
    }
  }

}
