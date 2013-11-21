require 'spec_helper_system'

describe 'cron::job define:' do
  context 'should run successfully' do
    pp = <<-EOS
class { 'cron': }
cron::job { 'logrotate':
  command     => '/usr/sbin/logrotate',
  user        => 'root',
  hour        => '1',
}

EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end

  describe cron do
    it { should have_entry('* 1 * * * /usr/sbin/logrotate').with_user('root') }
  end
end