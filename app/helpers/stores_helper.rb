module StoresHelper
  def img_credit n
    return nil if n.nil?
    ranks = %w(red blue cap crown)
    arr = n.divmod(5)
    if arr[1]==0
      arr[1] = 5
      arr[0] -= 1
    end
    image_tag("http://pics.taobaocdn.com/newrank/s_#{ranks[arr[0]]}_#{arr[1]}.gif",:class=>"credit",:height=>16,:width=>arr[1].to_i * 17 - 1)
  end
end
