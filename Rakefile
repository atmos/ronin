require File.expand_path(File.join(File.dirname(__FILE__), 'vendor', 'gems', 'environment'))
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'bundler'

spec = Gem::Specification.new do |s|
  s.name = "ronin"
  s.version = "0.0.1"
  s.author = "Corey Donohoe"
  s.email = "atmos@atmos.org"
  s.homepage = "http://github.com/atmos/ronin"
  s.description = s.summary = "A gem that provides some rogue like access..."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["LICENSE", 'TODO']

  # Uncomment this to add a dependency
  # s.add_dependency "foo"
  manifest = Bundler::Environment.load(File.dirname(__FILE__) + '/Gemfile')
  manifest.dependencies.each do |d|
    next if d.only && d.only.include?('test')
    s.add_dependency(d.name, d.version)
  end

  s.require_path = 'lib'
  s.files = %w(LICENSE README.md Rakefile TODO) + Dir.glob("{lib,spec}/**/*")

  s.bindir = "bin"
  s.executables = %w( ronin )
end

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
