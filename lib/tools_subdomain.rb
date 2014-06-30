# -*- encoding : utf-8 -*-
class ToolsSubdomain
  def self.matches?(request)
    %w(tool tools).include?(request.subdomain)
  end
end
