# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{RedCloth}
  s.version = "4.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Garber"]
  s.date = %q{2009-06-30}
  s.description = %q{RedCloth-4.2.2 - Textile parser for Ruby. http://redcloth.org/}
  s.email = %q{redcloth-upwards@rubyforge.org}
  s.executables = ["redcloth"]
  s.extensions = ["ext/redcloth_scan/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "README"]
  s.files = ["bin/redcloth", "CHANGELOG", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "README", "ext/redcloth_scan/extconf.rb"]
  s.homepage = %q{http://redcloth.org}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "RedCloth", "--main", "README"]
  s.require_paths = ["lib", "ext", "lib/case_sensitive_require"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{redcloth}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{RedCloth-4.2.2 - Textile parser for Ruby. http://redcloth.org/}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
