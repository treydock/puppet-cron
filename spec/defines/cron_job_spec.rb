require 'spec_helper'

describe 'cron::job' do
  include_context :defaults

  let(:facts) { default_facts }

  shared_context :cron_job_shared do
    it { should contain_class('cron::params') }
  end

  shared_context :cron_job_5min_shared do
    include_context :cron_job_shared

    let(:title) { 'cron.5min' }

    it do
      should contain_cron('cron.5min').with(cron_default_parameters.merge({
        'ensure'    => 'present',
        'command'   => 'run-part /etc/cron.5min',
        'user'      => 'root',
        'minute'    => '0,5,10,15,20,25,30,35,40,45,50,55',
      }))
    end
  end

  context 'with command => "run-part /etc/cron.5min" and run_part => true' do
    include_context :cron_job_5min_shared

    let :params do
      {
        :command    => 'run-part /etc/cron.5min',
        :user       => 'root',
        :minute     => '0,5,10,15,20,25,30,35,40,45,50,55',
        :run_part   => true,
      }
    end

    it { should contain_file('/etc/cron.5min').with_ensure('directory') }
  end

  context 'with command => "run-part etc/cron.5min" using invalid path and run_part => true' do
    let(:title) { 'cron.5min' }

    let :params do
      {
        :command    => 'run-part etc/cron.5min',
        :user       => 'root',
        :minute     => '0,5,10,15,20,25,30,35,40,45,50,55',
        :run_part   => true,
      }
    end

    it { expect { should contain_class('cron::params') }.to raise_error(Puppet::Error, /is not an absolute path./) }
  end

  context 'with command => "run-part /etc/cron.5min"' do
    include_context :cron_job_5min_shared

    let :params do
      {
        :command    => 'run-part /etc/cron.5min',
        :user       => 'root',
        :minute     => '0,5,10,15,20,25,30,35,40,45,50,55',
      }
    end

    it { should_not contain_file('/etc/cron.5min') }
  end

  context 'with command => /usr/sbin/logrotate' do
    include_context :cron_job_shared

    let(:title) { 'logrotate' }

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
    include_context :cron_job_shared

    let(:title) { '/usr/sbin/raid-check' }

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