require 'spec_helper_acceptance'

describe 'cron class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'cron': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe package('cronie') do
    it { should be_installed }
  end

  describe service('crond') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/sysconfig/crond') do
    its(:content) { should match /^CRONDARGS=$/ }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/cron.allow') do
    it { should_not be_file }
  end

  describe file('/etc/cron.deny') do
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  context "with cron_allow" do
    it "should run successfully" do
      pp =<<-EOS
        class { 'cron': cron_allow => ['root'] }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/cron.allow') do
      its(:content) { should match /^root$/ }
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end

  context "with default parameters" do
    it "should run successfully" do
      pp =<<-EOS
        class { 'cron': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/cron.allow') do
      it { should_not be_file }
    end
  end
end
