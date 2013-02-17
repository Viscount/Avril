class StatusesController < ApplicationController
  def index
    uri = URI("https://api.weibo.com/2/statuses/go.json?id=5958567199&uid=1065896203&access_token=2.00PS5IKBOwXVSB346c3ea479BMKhuD") 
    res = ''
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      res = JSON.parse(response.body)
    end
  end

  def get_statuses(page = 1)
    uri = URI("https://api.weibo.com/2/statuses/user_timeline.json?access_token=#{session['access_token']}&screen_name=greenmoon55&count=100&page=#{page}") 
    res = ''
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      res = JSON.parse(response.body)
    end
    return res
  end

  def analyze(res)
    res["statuses"].each do |status|
      @statuses << [status["text"], status["created_at"]]
      @counter += 1
    end
  end

  # 获取全部微博
  def all
    page = 1
    @counter = 0  # 总人数
    @statuses = Array.new
    begin
      res = get_statuses(page)
      page += 1
      analyze(res)
    end while res["total_number"] > (page - 1) * 100
  end

  def time
    @max_reposts_count = 0
    @max_comments_count = 0
    @text = ''
    page = 1
    @statuses = Array.new(24){0}
    begin
      res = get_statuses(page)
      page += 1
      analyze_time(res)
    end while res["total_number"] > (page - 1) * 100
  end
  
  def analyze_time(res)
    res["statuses"].each do |status|
      @statuses[status["created_at"].split[3][0..1].to_i] += 1
      if status["reposts_count"] > @max_reposts_count
        @max_reposts_count = status["reposts_count"]
        @max_reposts_count_weibo = status["id"]
      end
      if status["comments_count"] > @max_comments_count
        @max_comments_count = status["comments_count"]
        @max_comments_count_weibo = status["id"]
      end
      if status["attitudes_count"] > @max_comments_count
        @max_attitudes_count = status["attitudes_count"]
        @max_attitudes_count_weibo = status["id"]
      end
    end
  end
end
