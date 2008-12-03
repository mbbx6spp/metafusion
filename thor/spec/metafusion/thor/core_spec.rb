require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require('metafusion/thor/core')

describe Metafusion::Thor::Core do
  include Metafusion::Thor::Core
end

describe Metafusion::Thor::Core::ThorUndefinedProjectName do
  before(:all) do
    @class = Metafusion::Thor::Core::ThorUndefinedProjectName
  end
  
  it "should have superclass Exception" do
    @class.superclass.should be(Exception)
  end
end

describe Thor do
  before(:each) do
    @thor = Thor.new
  end
  
  describe "#project_name" do
    it "should raise PersonalLife::Core::ThorUndefinedProjectName exception when calling default project_name instance method" do
      lambda {
        @thor.project_name
      }.should raise_error(Metafusion::Thor::Core::ThorUndefinedProjectName)
    end
  end
  
  describe "#gem" do
    before(:each) do
      @project_name = "test"
      @gemspec_contents = ""
      @thor.stub!(:project_name).and_return(@project_name)
      File.stub!(:read).and_return(@gemspec_contents)
      @builder = mock(Gem::Builder)
      @builder.stub!(:build)
      Gem::Builder.stub!(:new).and_return(@builder)
    end
    
    it "should read [project_name].gemspec file" do
      File.should_receive(:read).with(@project_name + ".gemspec").and_return(@gemspec_contents)
      @thor.gem
    end
    
    it "should create a Gem::Builder object" do
      Gem::Builder.should_receive(:new).and_return(@builder)
      @thor.gem
    end
    
    it "should build the Gem::Builder object" do
      @builder.should_receive(:build)
      @thor.gem
    end
  end
end

