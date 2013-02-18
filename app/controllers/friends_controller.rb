class FriendsController < ApplicationController
  before_filter :connected_user
  def index
    @province_hash = get_province
    cursor = 0
    @counter = 0  # 总人数
    @provinces = Hash.new(0)
    @genders = Hash.new(0)
    begin
      res = get_friends(cursor)
      cursor += 200
      analyze(res)
    end while res["next_cursor"] > 0
  end

  def get_friends(cursor = 0)
    get("https://api.weibo.com/2/friendships/friends.json?access_token=#{session['access_token']}&screen_name=greenmoon55&count=200&cursor=#{cursor}") 
  end

  # 获取省份id对应名字的列表
  def get_province
    res = get("https://api.weibo.com/2/common/get_province.json?access_token=#{session['access_token']}&country=001") 
    h = Hash.new
    res.each {|x| h.merge!(x)}
    return h
  end

  # 根据id获取省份名称
  def get_name(raw_id)
    new_id = "0010" + raw_id
    @province_hash[new_id]
  end

  def analyze(res)
    res["users"].each do |user|
      @provinces[get_name(user["province"])] += 1
      @genders[user["gender"]] += 1
      @counter += 1
    end
  end
end
