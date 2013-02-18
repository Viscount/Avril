class ApplicationController < ActionController::Base
  protect_from_forgery
  def post(uri, params)
    uri = URI(uri)
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    http = Net::HTTP.new(uri.host, uri.port) 
    http.use_ssl = true if uri.scheme == 'https'
    res = http.request(req)
    response = JSON.parse(res.body)
  end
  def get(uri)
    uri = URI(uri)
    req = Net::HTTP::Get.new(uri.request_uri)
    http = Net::HTTP.new(uri.host, uri.port) 
    http.use_ssl = true if uri.scheme == 'https'
    res = http.request(req)
    response = JSON.parse(res.body)
  end
  def connected_user
    redirect_to new_connect_path if session['access_token'].nil?
  end
end
