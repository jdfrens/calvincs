Spec::Matchers.define :redirect_to do |redirection|
  match do |redirect_check|
    redirect_check.redirected?.should == true
    redirect_check.redirected_path.should == redirection
  end
end

module RedirectHelpers
  def get(url)
    RedirectCheck.new(ResourcePath.new("http://cs.calvin.edu" + url))
  end
end

