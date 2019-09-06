require 'rake'
require 'rake/testtask'
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'liquid2/version'

task :default => 'test'

Rake::TestTask.new(:test) do |t|
  t.libs << '.' << 'lib' << 'test'
  t.test_files = FileList['test/liquid2/**/*_test.rb']
  t.verbose = false
end

task :gem => :build
task :build do
  system "gem build liquid.gemspec"
end

task :install => :build do
  system "gem install liquid-#{Liquid2::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{Liquid2::VERSION} -m 'Tagging #{Liquid2::VERSION}'"
  system "git push --tags"
  system "gem push liquid-#{Liquid2::VERSION}.gem"
  system "rm liquid-#{Liquid2::VERSION}.gem"
end

namespace :benchmark do

  desc "Run the liquid benchmark"
  task :run do
    ruby "./performance/benchmark.rb"
  end

end


namespace :profile do

  desc "Run the liquid profile/performance coverage"
  task :run do
    ruby "./performance/profile.rb"
  end

  desc "Run KCacheGrind"
  task :grind => :run  do
    system "qcachegrind /tmp/liquid.rubyprof_calltreeprinter.txt"
  end

end

desc "Run example"
task :example do
  ruby "-w -d -Ilib example/server/server.rb"
end
