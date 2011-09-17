# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tanker}
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Francisco Viramontes", "Jack Danger Canty"]
  s.date = %q{2011-08-31}
  s.description = %q{IndexTank is a great search indexing service, this gem tries to make any orm keep in sync with indextank with ease}
  s.email = %q{kidpollo@gmail.com}
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = %q{http://github.com/kidpollo/tanker}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{IndexTank integration to your favorite orm}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.5.1"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<will_paginate>, [">= 2.3.15"])
      s.add_development_dependency(%q<kaminari>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 1.5.1"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<will_paginate>, [">= 2.3.15"])
      s.add_dependency(%q<kaminari>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.5.1"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<will_paginate>, [">= 2.3.15"])
    s.add_dependency(%q<kaminari>, [">= 0"])
  end
end
