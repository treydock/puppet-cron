require 'spec_helper'

describe 'cron' do
  include_context :defaults

  let :facts do
    default_facts.merge({

    })
  end

  it { should include_class('cron::params') }

  it do
    should contain_package('cronie').with({
      'ensure'  => 'installed',
    })
  end

  it { should_not contain_package('vixie-cron') }

  it do
    should contain_service('crond').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'crond',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'require'     => 'Package[cronie]',
    })
  end

  it do
    should contain_file('/etc/sysconfig/crond').with({
      'ensure'    => 'present',
      'owner'     => 'root',
      'group'     => 'root',
      'mode'      => '0644',
      'require'   => 'Package[cronie]',
      'notify'    => 'Service[crond]',
    })
  end

  it do
    should contain_file('/etc/sysconfig/crond') \
      .with_content(/^CRONDARGS=$/)
  end

  context 'EL5 contains vixie-cron' do
    let :facts do
      default_facts.merge({
        :operatingsystemrelease => '5.9'
      })
    end

    it do
      should contain_package('vixie-cron').with({
        'ensure'  => 'installed',
      })
    end

    it { should_not contain_package('cronie') }

    it do
      should contain_file('/etc/sysconfig/crond').with({
        'ensure'    => 'present',
        'owner'     => 'root',
        'group'     => 'root',
        'mode'      => '0644',
        'require'   => 'Package[vixie-cron]',
        'notify'    => 'Service[crond]',
      })
    end
  end

  context 'with job_instances => defined' do
    let :params do
      {
        :job_instances  => {
          '/path/to/foo'  => {
            'user' => 'root',
            'hour' => '1',
          }
        }
      }
    end

    it do
      should contain_cron('/path/to/foo').with(cron_default_parameters.merge({
        'ensure'    => 'present',
        'command'   => '/path/to/foo',
        'user'      => 'root',
        'hour'      => '1',
      }))
    end
  end

  context 'with crond_args => foo' do
    let :params do
      {
        :crond_args => 'foo',
      }
    end

    it do
      should contain_file('/etc/sysconfig/crond') \
        .with_content(/^CRONDARGS=foo$/)
    end
  end
end