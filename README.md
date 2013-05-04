# cron

This is the cron Puppet module.

## Usage

For a default crond installation

    class { 'cron': }

To define Puppet cron resources from an ENC, pass a Hash in the **job_instances**

    class { 'cron':
      job_instances =>  {
        'logrotate'   => {
          'command'     => '/usr/sbin/logrotate',
          'user'        => 'root',
          'hour'        => '1',
        }
      }
    }

Cron jobs can also be defined through this module by the **cron_job_instances** top-scope variable

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

## License

## Contact

## Support

Please log tickets and issues at our [Projects site](http://projects.example.com)
