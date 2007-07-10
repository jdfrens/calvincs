# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  @@STATIC_URLS = {
    :abet => 'http://www.abet.org/',
    :abstraction => 'http://clubs.calvin.edu/abstract/',
    :calvin => 'http://www.calvin.edu/',
    :csx => 'http://csx.calvin.edu/',
    :home => '/',
    :url_only => 'something',  # for testing... dumb, I know
  }
  
  @@STATIC_TEXT = {
    :abet => 'ABET',
    :abstraction => 'Abstraction',
    :calvin => 'Calvin College',
    :csx => 'CSX',
    :home => 'Computer Science Department',
  }
  
  def link_to_static(keyword, text='')
    if (@@STATIC_URLS[keyword] == nil) || (@@STATIC_TEXT[keyword] == nil)
      raise RuntimeError.new('invalid keyword for static link: ' + keyword.to_s)
    end
    '<a href="' + @@STATIC_URLS[keyword] + '">' +
      (text == '' ? @@STATIC_TEXT[keyword] : text) +
      '</a>'
  end
  
  def spinner_id(suffix = nil)
    suffix ? "spinner_#{suffix}" : "spinner"    
  end
  
  def spinner(options = {})
    id_suffix = options[:number] || options[:suffix]
    image_tag 'spinner_moz.gif', :id => spinner_id(id_suffix), :style => "display:none;"
  end
  
end
