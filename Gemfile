source 'https://rubygems.org'

# Specify your gem's dependencies in coderay.gemspec
gemspec

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "bundler", ">= 1.0.0"
  gem "rake"
  gem "RedCloth", RUBY_PLATFORM == 'java' ? ">= 4.2.7" : ">= 4.0.3"
  gem "term-ansicolor", '~> 1.3.0'
  gem "shoulda-context", "~> 1.1.2"
  gem "json" if RUBY_VERSION < '1.9'
  gem "rdoc"
end
