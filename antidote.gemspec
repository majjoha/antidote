$:.unshift(File.expand_path('../lib/', __FILE__))

require 'antidote/version'

Gem::Specification.new do |s|
  s.name        = "antidote-types"
  s.version     = Antidote::VERSION
  s.date        = "2015-09-19"
  s.summary     = "A highly experimental type assertion library"
  s.description = "Antidote is a small, highly experimental library that
                  performs runtime type assertions in Ruby"
  s.author      = ["Mathias Jean Johansen"]
  s.email       = "mathias@mjj.io"
  s.files       = Dir['README.md', 'LICENSE', 'lib/**/*']
  s.test_files  = Dir['spec/**/*.rb']
  s.homepage    = "https://github.com/majjoha/antidote"
  s.license     = "MIT"

  s.add_development_dependency 'rake', '~> 10.3.1'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'coveralls', '~> 0.7'
end
