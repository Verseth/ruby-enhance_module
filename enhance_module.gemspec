# frozen_string_literal: true

require_relative "lib/enhance_module/version"

Gem::Specification.new do |spec|
  spec.name = "enhance_module"
  spec.version = EnhanceModule::VERSION
  spec.authors = ["Mateusz Drewniak"]
  spec.email = ["matmg24@gmail.com"]

  spec.summary = "This gem adds a sorbet-friendly way of extending object instances with modules."
  spec.description = spec.summary
  spec.homepage = "https://github.com/Verseth/ruby-enhance_module"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ sorbet/ .git .gitlab-ci.yml appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "sorbet-runtime", ">= 0.5"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
