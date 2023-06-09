# frozen_string_literal: true

require_relative 'lib/rom/neighbor/version'

Gem::Specification.new do |spec|
  spec.name = 'rom-neighbor'
  spec.version = Rom::Neighbor::VERSION
  spec.authors = ['Jaigouk Kim']

  spec.summary = 'neighbor gem for rom-rb'
  spec.description = 'neighbor gem for rom-rb'
  spec.homepage = 'https://github.com/jaigouk/rom-neighbor'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jaigouk/rom-neighbor'
  spec.metadata['changelog_uri'] = 'https://github.com/jaigouk/rom-neighbor/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'pg', '~> 1.4'
  spec.add_dependency 'pgvector', '~> 0.1.1'

  spec.add_dependency 'rom', '~> 5.3'
  spec.add_dependency 'rom-sql', '~> 3.6'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
