class StatusesController < ApplicationController
  def index
    time
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
    page = 1
    @counter = 0  # 总人数
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
      @counter += 1
    end
  end
end
