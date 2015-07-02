Gem::Specification.new do |spec|
  spec.name          = 'lita-alias'
  spec.version       = '0.0.1'
  spec.authors       = ['Alex Soto']
  spec.email         = ['apsoto@gmail.com']
  spec.description   = 'A Lita Chatbot plugin to alias commands.'
  spec.summary       = 'A Lita Chatbot plugin to alias commands.'
  spec.homepage      = 'https://github.com/apsoto/lita-alias'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fakeredis'
end
