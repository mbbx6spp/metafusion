require 'rake/rdoctask'

desc 'Generate RDoc'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title = "Metafusion for Cryptography v#{Metafusion::Crypto::Version.to_version}: Cryptographic helper classes for Application Developers"
  rdoc.template = 'config/rdoc_template.rb'
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README' << '--line-numbers'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGES')
  rdoc.rdoc_files.include('MIT-LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('examples/**/*.rb')
end
