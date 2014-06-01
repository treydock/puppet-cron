require 'spec_helper_acceptance'

describe 'cron::job define:' do
  context 'logrotate' do
    it 'should run successfully' do
      pp = <<-EOS
      class { 'cron': }
      cron::job { 'logrotate':
        command     => '/usr/sbin/logrotate',
        user        => 'root',
        hour        => '1',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe cron do
    it { should have_entry('* 1 * * * /usr/sbin/logrotate').with_user('root') }
  end
end
