module ApplicationHelper
  def to_morris_data(hash)
    ("[" + hash.map {|k, v| "{label:'#{k}', value:#{v}}"}.join(',') + "]").html_safe
  end
end
