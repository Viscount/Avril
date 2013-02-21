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
    redirect_to connect_index_path
  end
end
