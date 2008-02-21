require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

VERSION_LIST = [Metafusion::Crypto::Version::MAJOR, Metafusion::Crypto::Version::MINOR, Metafusion::Crypto::Version::REVISION]

EXPECTED_VERSION = VERSION_LIST.join('.')
EXPECTED_NAME = VERSION_LIST.join('_')

describe Metafusion::Crypto::Version, ".to_version" do
  it "should return #{EXPECTED_VERSION}" do
    Metafusion::Crypto::Version.to_version.should eql(EXPECTED_VERSION)
  end
end

describe Metafusion::Crypto::Version, ".to_name" do
  it "should return #{EXPECTED_NAME}" do
    Metafusion::Crypto::Version.to_name.should eql(EXPECTED_NAME)
  end
end

