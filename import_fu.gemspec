# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{import_fu}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thibaud Guillaume-Gentil"]
  s.date = %q{2008-12-18}
  s.description = %q{Add quick mass data import from CSV or Array to Active Record model}
  s.email = %q{guillaumegentil@gmail.com}
  s.extra_rdoc_files = ["lib/import_fu.rb", "README.markdown"]
  s.files = ["import_fu.gemspec", "init.rb", "lib/import_fu.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.markdown", "test/database.yml", "test/fixtures/foos.csv", "test/import_fu_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/guillaumegentil/import_fu/tree}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Import_fu", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{import_fu}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Add quick mass data import from CSV or Array to Active Record model}
  s.test_files = ["test/import_fu_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<fastercsv>, [">= 0"])
      s.add_development_dependency(%q<active_record>, [">= 0"])
    else
      s.add_dependency(%q<fastercsv>, [">= 0"])
      s.add_dependency(%q<active_record>, [">= 0"])
    end
  else
    s.add_dependency(%q<fastercsv>, [">= 0"])
    s.add_dependency(%q<active_record>, [">= 0"])
  end
end
