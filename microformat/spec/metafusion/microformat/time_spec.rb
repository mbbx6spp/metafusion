require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Time do
  setup do
    @now = Time.now
    @abbr = @now.to_uformat
  end
    
  describe '#to_uformat' do
    it 'should conform to basic microformat pattern' do
      @abbr.should match(/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[-|+][0-9]{2}:?[0-9]{2}/)
    end
    
    it 'should render year in correct space' do
      re = Regexp.new("^#{@now.year}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[-|+][0-9]{2}:?[0-9]{2}")
      @abbr.should match(re)
    end

    it 'should render month in correct space' do
      re = Regexp.new("^[0-9]{4}-#{@now.month.zero_fill(2)}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[-|+][0-9]{2}:?[0-9]{2}")
      @abbr.should match(re)
    end
    
    it 'should render day in correct space' do
      re = Regexp.new("^[0-9]{4}-[0-9]{2}-#{@now.day.zero_fill(2)}T[0-9]{2}:[0-9]{2}:[0-9]{2}[-|+][0-9]{2}:?[0-9]{2}")
      @abbr.should match(re)
    end
    
    it 'should render hour in correct space' do
      re = Regexp.new("^[0-9]{4}-[0-9]{2}-[0-9]{2}T#{@now.hour.zero_fill(2)}:[0-9]{2}:[0-9]{2}[-|+][0-9]{2}:?[0-9]{2}")
      @abbr.should match(re)      
    end

    it 'should render minutes in correct space' do
      re = Regexp.new("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:#{@now.min.zero_fill(2)}:[0-9]{2}[-|+][0-9]{2}:?[0-9]{2}")
      @abbr.should match(re)      
    end

    it 'should render seconds in correct space' do
      re = Regexp.new("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:#{@now.sec.zero_fill(2)}[-|+][0-9]{2}:?[0-9]{2}")
      @abbr.should match(re)      
    end

    it 'should render UTC offset in correct space' do
      tz_offset = @now.strftime('%z')
      re = Regexp.new("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}#{tz_offset}")
      @abbr.should match(re)      
    end
  end
  
  describe '#to_html' do
    it 'should return valid microformat HTML snippet using defaults' do
      @now.to_html.should eql(%{<abbr class="published" title="#{@abbr}">#{@now.rfc2822}</abbr>})
    end
    
    it 'should return valid microformat HTML snippet using type => :updated' do
      @now.to_html(:created).should eql(%{<abbr class="created" title="#{@abbr}">#{@now.rfc2822}</abbr>})
    end
  end
end
