# puppet-cron

[![Build Status](https://travis-ci.org/treydock/puppet-cron.svg?branch=master)](https://travis-ci.org/treydock/puppet-cron)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration examples and options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for testing and contributing to the module](#development)

## Overview

This cron module installs, configures and manages the the cron service.

## Usage

The default behavior will ensure cron is installed and running with no restrictions on who can use cron.

    class { 'cron': }

The module can also define users who are allowed or denied access to cron.  The following example will configure cron to only allow the root user access to cron.

    class { 'cron':
      cron_allow  => ['root'],
    }

## Reference

### Classes

#### Public classes

* `cron` - Installs, configures and manages the cron service

### Parameters

#### cron

#####`crond_args`

String of arguments to pass to crond service.  Default is an empty string.

#####`package_name`

Name of the crond package. Default is OS dependent.

#####`service_ensure`

The crond service ensure value. Default is `'running'`.

#####`service_enable`

The crond service enable value. Default is `true`.

#####`service_config_path`

The path to the crond service config file. Default is OS dependent.

#####`service_config_template`

Template used for the crond service config. Default is OS dependent.

#####`service_name`

Name of the crond service. Default is OS dependent.

#####`service_hasstatus`

The crond service hasstatus value. Default is OS dependent.

#####`service_hasrestart`

The crond service hasrestart value. Default is OS dependent.

#####`cron_allow`

An array of users allowed to use cron. Default is `[]`, an empty array, which allows all users.

#####`cron_deny`

An array of users not allowed to use cron. Default is `[]`, an empty array, which denies no users.

## Limitations

Currently only supports Enterprise Linux based systems.

Adding support for other Linux distributions should only require
new variables being added to cron::params case statement.

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests.

    bundle exec rake beaker
