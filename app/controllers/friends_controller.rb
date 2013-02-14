class FriendsController < ApplicationController
  def index
    @province_table = get_province
    uri = URI("https://api.weibo.com/2/friendships/friends.json?access_token=#{session['access_token']}&screen_name=greenmoon55&count=200") 
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      res = JSON.parse(response.body)
      @res = Hash.new
      # 这里写得好丑= =!
      res["users"].each do |user|
        if @res[get_name(user["province"])].nil?
          @res[get_name(user["province"])] = 1
        else
          @res[get_name(user["province"])] += 1
        end
      end
    end
  end

  # 获取省份id对应名字的列表
  def get_province
    uri = URI("https://api.weibo.com/2/common/get_province.json?access_token=#{session['access_token']}&country=001") 
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      res = JSON.parse(response.body)
    end
  end

  # 改成完整的id
  def get_name(raw_id)
    new_id = "0010" + raw_id
    h = @province_table.detect {|p| p[new_id]}
    h[new_id] unless h.nil?
  end
end
