require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Metafusion::Microformat::Core do
  include Metafusion::Microformat::Core
  setup do
    @now = Time.now
  end
  
  describe 'render_tag' do
    it 'should render tag without block and no content' do
      tag = render_tag('meta', nil, :name => 'description', :content => 'This is the description of the page')
      tag.should eql('<meta content="This is the description of the page" name="description"/>')
    end
    
    it 'should render tag with content but no block defined or attributes' do
      tag = render_tag('li', 'A list item')
      tag.should eql('<li >A list item</li>')
    end
    
    it 'should render tag with content and attributes, but with no block defined' do
      tag = render_tag('li', 'A list item', :class => 'item')
      tag.should eql('<li class="item">A list item</li>')
    end
    
    it 'should render tag with block but not content defined' do
      tag = render_tag('div', nil, :class => 'entry') do
        render_tag('h1', 'The post title', :class => 'entry-title') + 
        render_tag('span', 'Some text goes in here!', :class => 'entry-content') +
        render_tag('abbr', @now.to_s, :title => @now.to_uformat, :class => 'published')
      end
      tag.should eql(%{<div class="entry"><h1 class="entry-title">The post title</h1><span class="entry-content">Some text goes in here!</span><abbr class="published" title="#{@now.to_uformat}">#{@now.to_s}</abbr></div>})
    end
  end
  
  describe 'render_timestamp' do
    it 'should render timestamp as defined by microformat standards' do
      tag = render_timestamp(@now)
      tag.should eql(%{<abbr class="published" title="#{@now.to_uformat}">#{@now.rfc2822}</abbr>})
    end
  end
end
