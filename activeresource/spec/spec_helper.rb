$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'spec'

def require_project_file(file)
  require(File.join(File.dirname(__FILE__), '..', 'lib', file))  
end

require_project_file('metafusion/active_resource')

# Spec helper that returns the project root directory as absolute path string
def project_root_dir
  File.expand_path(File.join(File.dirname(__FILE__), '..'))
end

