module ViewHelpers
  def should_have_spinner(options = {})
    id_suffix = options[:number] || options[:suffix]
    id = id_suffix ? "spinner_#{id_suffix}" : "spinner"
    response.should have_selector("img", :id => id) do |img|
      img.first['src'].should match(%r{^/images/spinner_moz.gif})
    end
  end

  def should_have_remote_form_for_and_spinner(id, route)
    response.should have_selector("form", :id => id) do |form|
      form.first['onsubmit'].should match(/Element\.show\('spinner/)
      form.first['onsubmit'].should match(/Element\.hide\('spinner/)
      form.first['onsubmit'].should match(/Ajax\.Request\('(.+?)'/)
      form.first["onsubmit"] =~ /Ajax\.Request\('(.+?)'/
      route.should == $1
    end
  end

  def expect_textilize_wop(text)
    template.should_receive(:textilize_without_paragraph).with(text).
            and_return(text)
  end

  def expect_textilize(text)
    template.should_receive(:textilize).with(text).and_return(text)
  end
end
