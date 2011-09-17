# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-core}
  s.version = "2.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chad Humphries", "David Chelimsky"]
  s.date = %q{2011-05-05}
  s.description = %q{RSpec runner and example groups}
  s.email = %q{dchelimsky@gmail.com;chad.humphries@gmail.com}
  s.executables = ["autospec", "rspec"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["bin/autospec", "bin/rspec", "README.md"]
  s.homepage = %q{http://github.com/rspec/rspec-core}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{rspec-core-2.5.2}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
