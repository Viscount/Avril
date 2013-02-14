# CLIENT_ID 什么的都在 config/initializers/weibo.rb 里
class ConnectController < ApplicationController
  
  # 请求授权
  def new
    redirect_to "https://api.weibo.com/oauth2/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
  end

  # 新浪重定向到这个地址，然后我们把新浪发过来到code参数发过去...
  # 就可以获取access_token
  def callback
    code = params[:code]
    #redirect_to "https://api.weibo.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=#{REDIRECT_URI}&code=#{code}"
    uri = URI("https://api.weibo.com/oauth2/access_token")
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data('client_id' => "#{CLIENT_ID}", 'client_secret' => "#{CLIENT_SECRET}", 'grant_type' => 'authorization_code', 'redirect_uri' => REDIRECT_URI, 'code' => code)
    access_token = ''
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      res = http.request(req)
      response = JSON.parse(res.body)
      access_token = response['access_token']
      session['access_token'] = access_token
    end
    uri = URI("https://api.weibo.com/2/users/show.json?access_token=#{session['access_token']}&screen_name=greenmoon55") 
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request # Net::HTTPResponse object
      @res = JSON.parse(response.body)
    end
  end
  def followers
    uri = URI("https://api.weibo.com/2/friendships/followers.json?access_token=#{session['access_token']}&screen_name=greenmoon55&count=200")
    res = ''
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request # Net::HTTPResponse object
      res = JSON.parse(response.body)
    end
    uri = URI("https://api.weibo.com/2/friendships/friends.json?access_token=#{session['access_token']}&uid=1065896203&count=200")
    res2 = ''
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request # Net::HTTPResponse object
      res2 = JSON.parse(response.body)
    end
  end
end
