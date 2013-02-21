# encoding: utf-8
module ApplicationHelper
  def to_morris_data(hash)
    ("[" + hash.map {|k, v| "{label:'#{k}', value:#{v}}"}.join(',') + "]").html_safe
  end
  def array_to_morris_data(array)
    i = -1
    ("[" + array.map{|x| 
      i += 1
      "{key: '#{i}时', value: #{x}}"
    }.join(',') + "]").html_safe
  end
end
