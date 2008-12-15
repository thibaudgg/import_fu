require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'echoe'

Echoe.new('import_fu', '0.1.1') do |p|
  p.description    = "Add quick mass data import from CSV or Array to Active Record model"
  p.url            = "http://github.com/guillaumegentil/import_fu/tree"
  p.author         = "Thibaud Guillaume-Gentil"
  p.email          = "guillaumegentil@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = ["fastercsv", "active_record"]
end