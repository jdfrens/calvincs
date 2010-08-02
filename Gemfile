source 'http://rubygems.org'

gem "rails", "=3.0.0.rc"
gem "sqlite3-ruby", :require => "sqlite3"

gem "RedCloth", :require => "redcloth"
gem "imagesize"
gem 'rcov'
gem "chronic"

group :test do
  gem "factory_girl"
  gem "test-unit", '~> 1.2'
  gem "rspec", ">= 2.0.0.beta.19"
  gem "rspec-rails", ">= 2.0.0.beta.19"
  gem "webrat"
  gem "timecop"
end

group :cucumber do
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'webrat'
  gem 'rspec', ">= 2.0.0.beta.19"
  gem 'rspec-rails', ">= 2.0.0.beta.19"
end

group :development do
  gem 'metric_fu'
  gem 'rails3-generators'
end
