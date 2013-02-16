class StatusesController < ApplicationController
  def index
    page = 1
    @counter = 0  # 总人数
    begin
      res = get_statuses(page)
      page += 1
      analyze(res)
    end while res["total_number"] > (page - 1) * 100
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

  # 改成完整的id
  def get_name(raw_id)
    new_id = "0010" + raw_id
    @province_hash[new_id]
  end

  def analyze(res)
    # 这里写得好丑= =!
    res["statuses"].each do |status|
      @counter += 1
    end
  end
end
