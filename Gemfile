source "https://rubygems.org"

group :development, :test do
  gem 'rake'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet-lint', '~> 0.3.2'
  gem 'puppet-syntax' unless ENV['PUPPET_GEM_VERSION'] =~ /2.6/
  gem 'travis-lint'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git', :ref => '8dc9ecbf0508fb8997dec23a2e555ed65af10538'
  gem 'rspec-system-puppet', '~> 2.0'
  #  gem 'rspec-system-serverspec', '~> 1.0'
  # Needed to use latest serverspec gem
  # PR submitted: https://github.com/puppetlabs/rspec-system-serverspec/pull/3
  gem 'rspec-system-serverspec', :git => 'git://github.com/nagas/rspec-system-serverspec.git', :branch => 'serverspec/0.x'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
