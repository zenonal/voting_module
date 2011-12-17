# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "XMLCanonicalizer"
  s.version = "1.0.1"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Roland Schmitt"]
  s.autorequire = "xmlanonicalizer"
  s.cert_chain = nil
  s.date = "2007-05-29"
  s.email = "Roland.Schmitt@web.de"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://www.rubyforge.org/projects/xmlcanonicalizer"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = "1.8.10"
  s.summary = "Implementation of w3c xml canonicalizer standart."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<log4r>, [">= 1.0.4"])
    else
      s.add_dependency(%q<log4r>, [">= 1.0.4"])
    end
  else
    s.add_dependency(%q<log4r>, [">= 1.0.4"])
  end
end
