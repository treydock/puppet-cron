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
      'require'   => 'Package[cronie]',
    }
  end

  let :default_facts do
    {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.4',
    }
  end
end