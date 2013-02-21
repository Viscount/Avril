# encoding: UTF-8
module StatusesHelper
  def go(uid, id)
    "http://api.weibo.com/2/statuses/go?uid=#{uid}&id=#{id}"
  end
  def months_to_morris_data(first_month, last_month, values)
    # 为什么不用each呢？因为可能某个月没发状态
    # Perhaps not the Ruby Way!
    str = '['
    for m in first_month..last_month do
      str += "{key: '#{m/12}年#{m%12+1}月', value: #{values[m]}}"
      str += ',' if m < last_month
    end
    str += ']'
    return str.html_safe
  end
end
