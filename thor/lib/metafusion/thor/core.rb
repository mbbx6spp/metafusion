# File that includes extensions to the Ruby standard library and core APIs
# in the Metafusion::Thor library.
module Metafusion
  module Thor
    # Module that contains core reusable features
    module Core
      class ThorUndefinedProjectName < Exception; end
    end
  end
end

require('thor')

class Thor
  def project_name
    raise ::Metafusion::Thor::Core::ThorUndefinedProjectName, "Please define a project_name methods in your Thor subclass that returns the name of your project"
  end
  
  desc "gem", "Build gem from .gemspec file"
  def gem
    path = project_name + ".gemspec"
    gemspec = eval(File.read(path))
    builder = Gem::Builder.new(gemspec)
    builder.build
  end
end

