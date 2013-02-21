# encoding: UTF-8
module StatusesHelper
  def go(uid, id)
    "http://api.weibo.com/2/statuses/go?uid=#{uid}&id=#{id}"
  end
end
