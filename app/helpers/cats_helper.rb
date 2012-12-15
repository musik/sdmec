# -*- encoding : utf-8 -*-
module CatsHelper
  def nested_ul(tree)
    
  end
  def nested_li(tree,id=nil)
    if tree[id].present?
      text = ""
      tree[id].each do |r|
        text += sprintf("<li>%s%s</li>",link_to(r.name,r),nested_li(tree,r.id))
      end
      "<ul>#{text}</ul>"
    else
      ""
    end
  end
end
