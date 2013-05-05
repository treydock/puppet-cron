# puppet-cron [![Build Status](https://travis-ci.org/treydock/puppet-cron.png)](https://travis-ci.org/treydock/puppet-cron)

This is the cron Puppet module.

## Support

Currently only supports Enterprise Linux based systems.

Adding support for other Linux distributions should only require
new variables being added to cron::params case statement.

## Usage

For a default crond installation

    class { 'cron': }

To define Puppet cron resources from an ENC, pass a Hash in the **job_instances** when defining the cron class.

    class { 'cron':
      job_instances =>  {
        'logrotate'   => {
          'command'     => '/usr/sbin/logrotate',
          'user'        => 'root',
          'hour'        => '1',
        }
      }
    }

Cron jobs can also be defined by defining the **cron_job_instances** top-scope variable.
This is could also be a way to define cron jobs from an ENC.

    $cron_job_instances = {
      'logrotate'   = {
        'command'     => '/usr/sbin/logrotate',
        'user'        => 'root',
        'hour'        => '1',
      }
    }

## Development

### Dependencies

* Ruby 1.8.7
* Bundler

### Running tests

1. To install dependencies run `bundle install`
2. Run tests using `rake spec:all`

