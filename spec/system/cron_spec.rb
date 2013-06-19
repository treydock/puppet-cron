require 'spec_helper_system'

describe 'cron class:' do
  context puppet_agent do
    its(:stderr) { should be_empty }
    its(:exit_code) { should_not == 1 }
  end

  context 'should run successfully' do
    pp = "class { 'cron': }"


    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
end
