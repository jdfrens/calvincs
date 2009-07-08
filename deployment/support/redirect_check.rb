class RedirectCheck

  attr_reader :source_path

  def initialize(source_path)
    @source_path = source_path.to_s
  end

  def uri
    URI.parse(source_path)
  end

  def response
    @response ||= Net::HTTP.start(uri.host, uri.port) {|http| http.head(uri.path) }
  end

  def success?
    response.is_a?(Net::HTTPOK)
  end

  def redirected?
    response.is_a?(Net::HTTPRedirection)
  end

  def permanent_redirect?
    redirected? && response.is_a?(Net::HTTPMovedPermanently)
  end

  def unauthorized?
    response.is_a?(Net::HTTPUnauthorized)
  end

  def redirected_path
    response['location'].sub(/#{Regexp.escape("#{uri.scheme}://#{uri.host}")}/, '') if redirected?
  end

end
