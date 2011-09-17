# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oa-oauth}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh"]
  s.date = %q{2010-04-29}
  s.description = %q{OAuth strategies for OmniAuth.}
  s.email = %q{michael@intridea.com}
  s.homepage = %q{http://github.com/intridea/omniauth}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{OAuth strategies for OmniAuth.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oa-core>, ["~> 0.0.0"])
      s.add_runtime_dependency(%q<oauth>, [">= 0"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<mg>, [">= 0"])
    else
      s.add_dependency(%q<oa-core>, ["~> 0.0.0"])
      s.add_dependency(%q<oauth>, [">= 0"])
      s.add_dependency(%q<oauth2>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<mg>, [">= 0"])
    end
  else
    s.add_dependency(%q<oa-core>, ["~> 0.0.0"])
    s.add_dependency(%q<oauth>, [">= 0"])
    s.add_dependency(%q<oauth2>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<mg>, [">= 0"])
  end
end
