require 'spec_helper'

describe 'cron' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('cron') }
  it { should contain_class('cron::params') }

  it do
    should contain_package('cron').with({
      'ensure'  => 'present',
      'name'    => 'cronie',
      'before'  => 'File[/etc/sysconfig/crond]',
    })
  end

  it do
    should contain_service('crond').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'crond',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'subscribe'   => 'File[/etc/sysconfig/crond]',
    })
  end

  it do
    should contain_file('/etc/sysconfig/crond').with({
      'ensure'    => 'present',
      'path'      => '/etc/sysconfig/crond',
      'owner'     => 'root',
      'group'     => 'root',
      'mode'      => '0644',
    })
  end

  it do
    content = catalogue.resource('file', '/etc/sysconfig/crond').send(:parameters)[:content]
    content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
      'CRONDARGS=',
    ]
  end

  it { should contain_file('/etc/cron.allow').with_ensure('absent') }

  it do
    should contain_file('/etc/cron.deny').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0600',
    })
  end

  it "should contain /etc/cron.deny with no content" do
    content = catalogue.resource('file', '/etc/cron.deny').send(:parameters)[:content]
    content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == []
  end

  it { should have_cron__job_resource_count(0) }

  context 'EL5 contains vixie-cron' do
    let(:facts) { default_facts.merge({ :operatingsystemrelease => '5.9' }) }
    it { should contain_package('cron').with_name('vixie-cron') }
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

  context 'with job_instances => {}' do
    let(:params) {{ :job_instances  => {} }}
    it { should have_cron__job_resource_count(0) }
  end

  context 'with crond_args => foo' do
    let(:params) {{ :crond_args => 'foo' }}

    it do
      content = catalogue.resource('file', '/etc/sysconfig/crond').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
        'CRONDARGS=foo',
      ]
    end
  end

  context 'when cron_allow => ["foo", "bar"]' do
    let(:params) {{ :cron_allow => ["foo", "bar"] }}

    it do
      should contain_file('/etc/cron.allow').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
      })
    end

    it "should contain /etc/cron.allow with valid contents" do
      content = catalogue.resource('file', '/etc/cron.allow').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == ["foo","bar"]
    end
  end

  context 'when cron_deny => ["foo", "bar"]' do
    let(:params) {{ :cron_deny => ["foo", "bar"] }}

    it "should contain /etc/cron.deny with valid contents" do
      content = catalogue.resource('file', '/etc/cron.deny').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == ["foo","bar"]
    end
  end
end