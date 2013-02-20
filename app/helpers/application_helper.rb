module ApplicationHelper
  def to_morris_data(hash)
    ("[" + hash.map {|k, v| "{label:'#{k}', value:#{v}}"}.join(',') + "]").html_safe
  end
  def array_to_morris_data(array)
    i = 0
    "[" + array.map{|x| 
      i += 1
      "{key: #{i}, value: #{x}}"
    }.join(',') + "]"
  end
end
