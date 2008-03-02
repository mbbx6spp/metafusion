# File that includes extensions to the Ruby standard library

class Time
  def to_uformat
    strftime('%Y-%m-%dT%H:%M:%S%z')
  end
  
  def to_html(type = :published, format = nil, &block)
    format ||= to_uformat
    %{<abbr class="#{type}" title="#{format}">#{block ? block.call : rfc2822}</abbr>}
  end
end

class Numeric
  def zero_fill(length = 3)
    sprintf("%0#{length}d", self)
  end
end

class Hash
  def to_html_attrs
    collect do |key, val|
      "#{key}=\"#{val}\""
    end.join(' ')
  end
end

module Metafusion
  module Microformat
    # Module that contains core reusable features
    module Core
      def render_tag(name, content = nil, attributes = {}, &block)
        def _tag_with_content(name, content, attributes)
          "<#{name} #{attributes.to_html_attrs}>#{content}</#{name}>"
        end
        if content && !block
          _tag_with_content(name, content, attributes)
        elsif !content && !block
          "<#{name} #{attributes.to_html_attrs}/>"
        elsif block
          content = block.call
          _tag_with_content(name, content, attributes)
        end
      end
    
      def render_timestamp(ts = nil)
        ts ||= Time.now
        ts.to_html
      end
      
      # Renders a HEntry HTML snippet.
      # 
      # +entry+ parameter is expected to be a Hash object with the following attributes:
      # * :id: - the entry numeric id
      # * :title: - the entry title
      # * :content: - the entry content
      # * :published_at: - the publish timestamp for the entry
      # * :author: - the author information (again in Hash format) [optional]
      # * :comment_count: - the number of comments for the entry [optional]
      # 
      # For example, the following would be a proper use of this render method
      #  <%= render_entry(:id => 23432343, :title => 'My blog entry', :content => 'My content goes here') -%>
      def render_entry(entry)
        %{<div class="hentry" id="#{entry[:id]}">
          <h2 class="entry-title">#{entry[:title]}</h2>
          <span class="entry-content">#{entry[:content]}</span>
          #{entry[:published_at].to_html}
          <span class="byline">Posted by <span class="author vcard"><span class="fn"
        }
      end
      
      def render_card(person)
        
      end
    end
  end
end

