# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "log4r"
  s.version = "1.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colby Gutierrez-Kraybill"]
  s.date = "2010-10-28"
  s.description = "See also: http://logging.apache.org/log4j"
  s.email = "colby@astro.berkeley.edu"
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["README", "LICENSE", "TODO"]
  s.homepage = "http://log4r.rubyforge.org"
  s.require_paths = ["lib"]
  s.rubyforge_project = "log4r"
  s.rubygems_version = "1.8.10"
  s.summary = "Log4r, logging framework for ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
