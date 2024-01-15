# frozen_string_literal: true

require_relative "lib/canary/version"

Gem::Specification.new do |spec|
  spec.name = "canary"
  spec.version = Canary::VERSION
  spec.authors = ["Jeremy Ward"]
  spec.email = ["jrmy.ward@gmail.com"]

  spec.summary = "CLI application that will allow us to test an EDR agent and ensure it generates the appropriate telemetry."
  spec.description = "CLI application that will allow us to test an EDR agent and ensure it generates the appropriate telemetry."
  spec.homepage = ""
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "standard"
end
