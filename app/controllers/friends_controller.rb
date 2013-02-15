class FriendsController < ApplicationController
  def index
    @province_hash = get_province
    cursor = 0
    @counter = 0  # 总人数
    @h = Hash.new
    begin
      res = get_friends(cursor)
      cursor += 200
      analyze(res)
    end while res["next_cursor"] > 0
    return @res = @h
  end

  def get_friends(cursor = 0)
    uri = URI("https://api.weibo.com/2/friendships/friends.json?access_token=#{session['access_token']}&screen_name=greenmoon55&count=200&cursor=#{cursor}") 
    res = ''
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      res = JSON.parse(response.body)
    end
    return res
  end

  # 获取省份id对应名字的列表
  def get_province
    uri = URI("https://api.weibo.com/2/common/get_province.json?access_token=#{session['access_token']}&country=001") 
    res = ''
    h = Hash.new
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      res = JSON.parse(response.body)
      res.each {|x| h.merge!(x)}
    end
    return h
  end

  # 改成完整的id
  def get_name(raw_id)
    new_id = "0010" + raw_id
    @province_hash[new_id]
  end

  def analyze(res)
    # 这里写得好丑= =!
    res["users"].each do |user|
      if @h[get_name(user["province"])].nil?
        @h[get_name(user["province"])] = 1
      else
        @h[get_name(user["province"])] += 1
      end
      @counter += 1
    end
  end
end
