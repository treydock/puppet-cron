require 'puppetlabs_spec_helper/module_spec_helper'

begin
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter '/spec/'
  end
rescue Exception => e
  warn "Coveralls disabled"
end

shared_context :defaults do  
  let :cron_default_parameters do
    {
      'user'      => nil,
      'minute'    => nil,
      'hour'      => nil,
      'month'     => nil,
      'monthday'  => nil,
      'weekday'   => nil,
      'special'   => nil,
      'require'   => 'Package[cron]',
    }
  end

  let :default_facts do
    {
      :kernel                 => 'Linux',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.4',
      :architecture           => 'x86_64',
    }
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
