require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
begin
  require 'puppet-syntax/tasks/puppet-syntax'
rescue LoadError
end
require 'rspec-system/rake_task'

task :default do
  sh %{rake -T}
end

desc "Run rspec-puppet and puppet-lint tasks"
task :ci do
  Rake::Task[:syntax].invoke unless ENV['PUPPET_GEM_VERSION'] =~ /2.6/
  Rake::Task[:lint].invoke
  Rake::Task[:spec].invoke
end

# Disable puppet-lint checks
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_class_inherits_from_params_class")

# Ignore files outside this module
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp", "vendor/**/*.pp", "spec/**/*.pp"]
PuppetSyntax.exclude_paths = ["pkg/**/*.pp", "vendor/**/*.pp", "spec/**/*.pp"] unless ENV['PUPPET_GEM_VERSION'] =~ /2.6/
