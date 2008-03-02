require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

VERSION_LIST = [Metafusion::Microformat::Version::MAJOR, Metafusion::Microformat::Version::MINOR, Metafusion::Microformat::Version::REVISION]

EXPECTED_VERSION = VERSION_LIST.join('.')
EXPECTED_NAME = VERSION_LIST.join('_')

describe Metafusion::Microformat::Version, ".to_version" do
  it "should return #{EXPECTED_VERSION}" do
    Metafusion::Microformat::Version.to_version.should eql(EXPECTED_VERSION)
  end
end

describe Metafusion::Microformat::Version, ".to_name" do
  it "should return #{EXPECTED_NAME}" do
    Metafusion::Microformat::Version.to_name.should eql(EXPECTED_NAME)
  end
end

