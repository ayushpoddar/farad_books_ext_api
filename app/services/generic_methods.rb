class GenericMethods

  # Check if a given URL is valid
  def self.valid_url? string
    begin
      uri = URI.parse(string)
      return uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue => e
      false
    end
  end


  # # Get size and content type of a file to be downloaded via URL
  def self.get_size_and_content_type_of_url_file url
    resp = HTTParty.head url
    size = resp.headers['content-length'].to_f
    content_type = resp.headers['Content-Type']
    { size: size, content_type: content_type }
  end

  # def self.get_size_and_content_type_of_url_file url
  #   url = URI(url)
  #   http = Net::HTTP.new(url.host, url.port)
  #   request = Net::HTTP::Head.new(url)
  #   resp = http.request(request)
  #   size = resp.header['content-length'].to_f
  #   content_type = resp.header['Content-Type']
  #   { size: size, content_type: content_type }
  # end

end
