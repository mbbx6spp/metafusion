require('rake/contrib/rubyforgepublisher')

namespace :web do
  desc "Build the website, but do not publish it"
  task :build => [:clobber, :coverage, :spec, :webgen, :rdoc]

  desc "Upload Website to RubyForge"
  task :publish => [:verify_user, :website] do
    publisher = Rake::SshDirPublisher.new(
      "rspec-website@rubyforge.org",
      "/var/www/gforge-projects/metafusion/crypto",
      "doc/output"
    )
    publisher.upload
  end
end
