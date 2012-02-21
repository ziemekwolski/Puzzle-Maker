require 'rake/gempackagetask'
require 'rake/testtask'
require './lib/kaleidoscope/version'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.verbose = true
  t.pattern = 'test/*_test.rb'
end


spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Generate Puzzle pattern"
  s.name = 'Puzzle Generator'
  s.version = PuzzleGenerator::Version::STRING
  s.files = FileList["README.md", "Rakefile", "lib/**/*.rb", "examples/**/*.rb", "test/**/*.rb"].to_a
  s.description = <<-STR
Creates a puzzle simple puzzle structure using a matrix and rmagick.
STR
  s.author = "Ziemek Wolski"
  s.email = "ziemek.wolski+puzzle_generator@gmail.com"
  s.homepage = ""
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :clean do
 rm_rf ["pkg", "*.png"]
end