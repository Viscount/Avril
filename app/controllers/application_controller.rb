class ApplicationController < ActionController::Base
  protect_from_forgery
  def post(uri, params)
    uri = URI(uri)
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    https = Net::HTTP.new(uri.host, uri.port) 
    https.use_ssl = true if uri.scheme == 'https'
    res = https.request(req)
    response = JSON.parse(res.body)
  end
end
