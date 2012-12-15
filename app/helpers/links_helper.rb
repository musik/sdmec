# -*- encoding : utf-8 -*-
module LinksHelper
  def pp_link data
    data.split("\r\n").collect do |str|
      eval str.sub(/^ +/,'')
    end.join(" ").html_safe rescue nil
  end
end
