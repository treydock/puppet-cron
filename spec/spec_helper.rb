require 'puppetlabs_spec_helper/module_spec_helper'

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