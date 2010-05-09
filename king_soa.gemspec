# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{king_soa}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Georg Leciejewski"]
  s.date = %q{2010-05-09}
  s.description = %q{Creating a SOA requires a centralized location to define all services within the
SOA. KingSoa takes care of keeping services in a service registry and knows how to call them.
}
  s.email = %q{gl@salesking.eu}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
     "lib/king_soa.rb",
     "lib/king_soa/rack/middleware.rb",
     "lib/king_soa/registry.rb",
     "lib/king_soa/service.rb",
     "spec/king_soa/rack/middleware_spec.rb",
     "spec/king_soa/registry_spec.rb",
     "spec/king_soa/service_spec.rb",
     "spec/server/app.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/salesking/king_soa}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Abstraction layer for SOA-Services}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/king_soa/registry_spec.rb",
     "spec/king_soa/service_spec.rb",
     "spec/king_soa/rack/middleware_spec.rb",
     "spec/server/app.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<typhoeus>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<resque>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<typhoeus>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<resque>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<typhoeus>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<resque>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
  end
end

