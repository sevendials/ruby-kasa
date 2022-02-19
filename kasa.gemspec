# frozen_string_literal: true

require_relative "lib/kasa/version"

Gem::Specification.new do |spec|
  spec.name          = "kasa"
  spec.version       = Kasa::VERSION
  spec.authors       = ["Christopher Jenkins"]
  spec.email         = ["christj@gmail.com"]

  spec.summary       = "TP-Link Kasa"
  spec.description   = "Directly control Kasa devices"
  spec.homepage      = "https://github.com/sevendials/ruby-kasa"
  spec.required_ruby_version = ">= 2.6.0"
  spec.license = "GPL-3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sevendials/ruby-kasa"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'json', '~> 2.6'
  spec.add_dependency 'timeout', '~> 0.1'
  spec.add_dependency 'base64', '~> 0.1'
  spec.add_dependency 'logger', '~> 1.4'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency "rubocop-rspec", "~> 2.8"
  spec.add_development_dependency "irb", "~> 1.4"
  spec.add_development_dependency "rdoc", "~> 6.4"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
