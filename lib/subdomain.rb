# -*- encoding : utf-8 -*-
class Subdomain
  def self.matches?(request)
    request.subdomain.present? && !%w(www tool tools).include?(request.subdomain)
  end
end
