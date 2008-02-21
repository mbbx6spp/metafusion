# version.rb contains <tt>Metafusion::Crypto::Version</tt> that provides helper
# methods related to versioning of the <tt>Metafusion::Crypto4R</tt> project.

module Metafusion::Crypto::Version #:nodoc:
  MAJOR = 0
  MINOR = 1
  REVISION = 0
  class << self
    # Returns X.Y.Z formatted version string
    def to_version
      "#{MAJOR}.#{MINOR}.#{REVISION}"
    end
    
    # Returns X-Y-Z formatted version name
    def to_name
      "#{MAJOR}_#{MINOR}_#{REVISION}"
    end
  end
end
