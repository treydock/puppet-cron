require 'spec_helper'

describe 'cron' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { should create_class('cron') }
      it { should contain_class('cron::params') }

      if facts[:operatingsystemmajrelease].to_i >= 6
        it do
          should contain_package('cron').with({
            :ensure => 'present',
            :name   => 'cronie',
            :before => 'File[/etc/sysconfig/crond]',
          })
        end
      else
        it do
          should contain_package('cron').with({
            :ensure => 'present',
            :name   => 'vixie-cron',
            :before => 'File[/etc/sysconfig/crond]',
          })
        end
      end

      it do
        should contain_service('crond').with({
          :ensure     => 'running',
          :enable     => 'true',
          :name       => 'crond',
          :hasstatus  => 'true',
          :hasrestart => 'true',
          :subscribe  => 'File[/etc/sysconfig/crond]',
        })
      end

      it do
        should contain_file('/etc/sysconfig/crond').with({
          :ensure => 'present',
          :path   => '/etc/sysconfig/crond',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0644',
        })
      end

      it do
        content = catalogue.resource('file', '/etc/sysconfig/crond').send(:parameters)[:content]
        expect(content.split("\n").reject { |c| c =~ /(^#|^$)/ }).to eq([
          'CRONDARGS=',
        ])
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
        expect(content.split("\n").reject { |c| c =~ /(^#|^$)/ }).to eq([])
      end

      context 'with crond_args => foo' do
        let(:params) {{ :crond_args => 'foo' }}

        it do
          content = catalogue.resource('file', '/etc/sysconfig/crond').send(:parameters)[:content]
          expect(content.split("\n").reject { |c| c =~ /(^#|^$)/ }).to eq([
            'CRONDARGS=foo',
          ])
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
          expect(content.split("\n").reject { |c| c =~ /(^#|^$)/ }).to eq(["foo","bar"])
        end
      end

      context 'when cron_deny => ["foo", "bar"]' do
        let(:params) {{ :cron_deny => ["foo", "bar"] }}

        it "should contain /etc/cron.deny with valid contents" do
          content = catalogue.resource('file', '/etc/cron.deny').send(:parameters)[:content]
          expect(content.split("\n").reject { |c| c =~ /(^#|^$)/ }).to eq(["foo","bar"])
        end
      end
    end
  end
end