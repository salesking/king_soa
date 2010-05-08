require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "king_soa"
    gem.summary = %Q{Registry and deployment description abstraction for SOA-Services by SalesKing}
    gem.description = <<-DESCRIPTION
Creating a SOA requires a centralized location to define all services within the
SOA. Furthermore you want to know where to deploy those services.
DESCRIPTION
    gem.email = "gl@salesking.eu"
    gem.homepage = "http://github.com/salesking/king_soa"
    gem.authors = ['Georg Leciejewski']
    gem.files = FileList["[A-Z]*.*", "{lib,spec}/**/*"]

    gem.add_dependency "typhoeus"
    gem.add_dependency "json"
    
    gem.add_development_dependency "rspec"
#    gem.add_development_dependency "rack/test"
#    gem.add_development_dependency "webmock"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.rcov = true
  spec.rcov_opts = ['--exclude', 'spec']
  spec.rcov_opts << '--sort coverage'
  spec.rcov_opts << '--sort-reverse '
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "KingSoa #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
