# frozen_string_literal: true

require_relative "lib/nervous/system/version"

Gem::Specification.new do |spec|
  spec.name          = "nervous-system"
  spec.version       = Nervous::System::VERSION
  spec.authors       = ["Julian Nadeau"]
  spec.email         = ["julian@jnadeau.ca"]

  spec.summary       = "Connecting sources of informatiton to a centralized notes location."
  spec.description   = <<~DESC
    The Nervous System is a tool for connecting information sources to a centralized notes location (aka the Brain)
    It's primary goal is to allow information sources to be added and removed dynamically, and to provide a unified interface for accessing information.
  DESC

  spec.homepage      = "https://github.com/jules2689/nervous-system"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jules2689/nervous-system"
  spec.metadata["changelog_uri"] = "https://github.com/jules2689/nervous-system"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "kiba"
  spec.add_dependency "kiba-common"
  spec.add_dependency "rake"
  spec.add_dependency "sqlite3"
  spec.add_dependency "standalone_migrations", "~> 6.0.0"
  spec.add_dependency "todoist-ruby"
end
