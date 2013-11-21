require 'spec_helper_system'

describe 'cron class:' do
  context 'should run successfully' do
    pp =<<-EOS
class { 'cron': }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
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
end
