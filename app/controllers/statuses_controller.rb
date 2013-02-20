class StatusesController < ApplicationController
  before_filter :connected_user
  def index
    time
  end

  def get_statuses(page = 1)
    get("https://api.weibo.com/2/statuses/user_timeline.json?access_token=#{session['access_token']}&count=100&page=#{page}") 
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
    @times = Hash.new(0)
    @max_reposts_count = 0
    @max_comments_count = 0
    @max_attitudes_count = 0
    @text = ''
    page = 1
    @statuses = Array.new(24){0}
    @source = Hash.new
    @source.default = 0
    res = ''
    begin
      res = get_statuses(page)
      page += 1
      analyze_time(res)
      analyze_source(res)
    end while res["total_number"] > (page - 1) * 100
    @first_status = res["statuses"][-1]
    @last_month = Time.now.year * 12 + Time.now.month-1
    time = DateTime.strptime(@first_status['created_at'], '%a %b %e %T %z %Y')
    @first_month = time.year * 12 + time.month-1
    @total_days = (Time.now - time).to_i / 1.day
    @counter = res["total_number"]
  end
  
  def analyze_time(res)
    res["statuses"].each do |status|
      @statuses[status["created_at"].split[3][0..1].to_i] += 1
      if status["reposts_count"] >= @max_reposts_count
        @max_reposts_count = status["reposts_count"]
        @max_reposts_count_weibo = status
        @max_reposts_count_id = status["id"]
      end
      if status["comments_count"] >= @max_comments_count
        @max_comments_count = status["comments_count"]
        @max_comments_count_weibo = status
        @max_comments_count_id = status["id"]
      end
      if status["attitudes_count"] >= @max_attitudes_count
        @max_attitudes_count = status["attitudes_count"]
        @max_attitudes_count_weibo = status
        @max_attitudes_count_id = status["id"]
      end
      datetime = DateTime.strptime(status["created_at"], '%a %b %e %T %z %Y')
      @times[datetime.year * 12 + datetime.month-1] += 1
    end
  end

  def analyze_source(res)
    res["statuses"].each do |status|
      if @source.has_key?(status["source"])
       @source[status["source"]] += 1
      else
       @source.store(status["source"],1)
      end
    end
  end
end
