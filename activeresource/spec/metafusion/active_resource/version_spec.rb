require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

VERSION_LIST = [Metafusion::ActiveResource::Version::MAJOR, Metafusion::ActiveResource::Version::MINOR, Metafusion::ActiveResource::Version::REVISION]

EXPECTED_VERSION = VERSION_LIST.join('.')
EXPECTED_NAME = VERSION_LIST.join('_')

describe Metafusion::ActiveResource::Version, ".to_version" do
  it "should return #{EXPECTED_VERSION}" do
    Metafusion::ActiveResource::Version.to_version.should eql(EXPECTED_VERSION)
  end
end

describe Metafusion::ActiveResource::Version, ".to_name" do
  it "should return #{EXPECTED_NAME}" do
    Metafusion::ActiveResource::Version.to_name.should eql(EXPECTED_NAME)
  end
end

