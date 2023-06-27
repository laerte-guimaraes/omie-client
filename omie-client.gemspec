# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omie/version'

Gem::Specification.new do |spec|
  spec.name          = 'omie-client'
  spec.version       = Omie::VERSION
  spec.authors       = ['Peerdustry']
  spec.email         = ['contato@peerdustry.com']

  spec.summary       = 'A Ruby client for Omie ERP API'
  spec.description   = 'A Ruby client for Omie ERP API'
  spec.homepage      = 'https://gitlab.com/peerdustry/floss/omie-client'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'

  # development dependencies
  spec.add_development_dependency 'bundler', '~> 2.4.2'
  spec.add_development_dependency 'cpf_cnpj', '~> 0.5'
  spec.add_development_dependency 'factory_bot', '>= 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'

  # development dependencies
  spec.add_dependency 'activesupport', '>= 5.0'
  spec.add_dependency 'byebug', '~> 11.1.3'
  spec.add_dependency 'rest-client', '>= 2.0'
end
