# -*- encoding : utf-8 -*-
class SiteSubdomain
  #def self.matches?(request)
    #request.subdomain.present? &&
      #request.subdomain.length > 3 &&
        #!APP_CONFIG[:site_excludes].include?(request.subdomain)
  #end
  def self.matches?(request)
    request.subdomain.present? && request.subdomain == 'site'
  end
end
