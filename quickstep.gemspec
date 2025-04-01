# frozen_string_literal: true

require_relative 'lib/quickstep/version'

Gem::Specification.new do |spec|
  spec.name = 'quickstep'
  spec.version = Quickstep::VERSION
  spec.authors = ['Igor Korepanov']
  spec.email = ['korepanovigor87@gmail.com']

  spec.summary = 'A lightweight business operation tool.'
  spec.description = <<-DESC
    Quickstep provides a structured way to execute multi-step business operations with built-in success and
    failure handling.
  DESC
  spec.homepage = 'https://github.com/igorkorepanov/quickstep'
  spec.files = Dir.glob('{lib}/**/*') + %w[LICENSE.txt README.md]
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
