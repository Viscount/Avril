# CLIENT_ID 什么的都在 config/initializers/weibo.rb 里
class ConnectController < ApplicationController
  before_filter :connected_user, except: [:new, :callback]
  def index
    @res = get("https://api.weibo.com/2/users/show.json?access_token=#{session['access_token']}&uid=#{session['uid']}")
  end
  
  # 请求授权
  def new
    redirect_to "https://api.weibo.com/oauth2/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
  end

  # 新浪重定向到这个地址，然后我们把新浪发过来到code参数发过去...
  # 就可以获取access_token
  def callback
    p = {'client_id' => "#{CLIENT_ID}", 'client_secret' => "#{CLIENT_SECRET}", 'grant_type' => 'authorization_code', 'redirect_uri' => REDIRECT_URI, 'code' => params['code']}
    response = post("https://api.weibo.com/oauth2/access_token", p)
    session['access_token']= response['access_token']
    session['uid']= response['uid']
    @res = response
  end

  # 暂时没用到
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

  def connected_user
    redirect_to new_connect_path if session['access_token'].nil?
  end
end
