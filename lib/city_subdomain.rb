# -*- encoding : utf-8 -*-
class CitySubdomain
  def self.matches?(request)
    APP_CONFIG[:city_slugs].include?(request.subdomain)
  end
end
