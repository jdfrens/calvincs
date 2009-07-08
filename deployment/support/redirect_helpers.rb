Spec::Matchers.define :redirect_to do |redirection|
  match do |original|
    original.redirected?.should == true
    original.redirected_path.should == redirection
  end
end

module RedirectHelpers
  def get(url)
    RedirectCheck.new(ResourcePath.new("http://cs.calvin.edu" + url))
  end
end

