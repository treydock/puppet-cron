require 'spec_helper'

describe 'cron::job' do
  include_context :default_parameters

  let :facts do
    RSpec.configuration.default_facts.merge({

    })
  end

  context 'with command => "run-part /etc/cron.5min"' do
    let :title do
      'cron.5min'
    end

    let :params do
      {
        :command    => 'run-part /etc/cron.5min',
        :user       => 'root',
        :minute     => '0,5,10,15,20,25,30,35,40,45,50,55',
      }
    end

    it { should include_class('cron') }

    it do
      should contain_cron('cron.5min').with(cron_default_parameters.merge({
        'ensure'    => 'present',
        'command'   => 'run-part /etc/cron.5min',
        'user'      => 'root',
        'minute'    => '0,5,10,15,20,25,30,35,40,45,50,55',
      }))
    end

    it do
      should contain_file('/etc/cron.5min').with_ensure('directory')
    end
  end

  context 'with command => /usr/sbin/logrotate' do
    let :title do
      'logrotate'
    end

    it { should include_class('cron') }

    let :params do
      {
        :command => '/usr/sbin/logrotate',
        :user    => 'root',
        :minute  => '*/10',
      }
    end

    it do
      should contain_cron('logrotate').with(cron_default_parameters.merge({
        'ensure'    => 'present',
        'command'   => '/usr/sbin/logrotate',
        'user'      => 'root',
        'minute'    => '*/10',
      }))
    end
  end

  context 'with name as command' do
    let :title do
      '/usr/sbin/raid-check'
    end

    it { should include_class('cron') }

    let :params do
      {
        :user     => 'root',
        :minute   => '0',
        :hour     => '1',
        :weekday  => 'Sun',
      }
    end

    it do
      should contain_cron('/usr/sbin/raid-check').with(cron_default_parameters.merge({
        'ensure'    => 'present',
        'command'   => '/usr/sbin/raid-check',
        'user'      => 'root',
        'minute'    => '0',
        'hour'      => '1',
        'weekday'   => 'Sun',
      }))
    end
  end
end