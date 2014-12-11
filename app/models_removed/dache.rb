# -*- encoding : utf-8 -*-
class Dache < ActiveRecord::Base
  #attr_accessible :context_type, :context_id, :value
  
  def val
    # return nil if self[:value].nil? 
    self[:value].is_a?(String) ? YAML.load(self[:value]) : self[:value]
  end
  def move_to_kt
    Kts.fetch context_type,:expires_in => 7.day do
      val
    end
    destroy
  end
  class << self
    def fetch context_type,context_id=nil,options={},&block
      defaults = {
        :force => false,
        :expires_in => nil
      }
      options= defaults.merge! options 
      
      cond = {:context_type=>context_type,:context_id=>context_id}
      e = where(cond).first
      nu = false #need update 
      if e.present?
        if options[:force] != false 
          nu = true
        elsif options[:expires_in].present?
          nu = true if e.updated_at + options[:expires_in] < Time.now
        end
      else
       nu = true
      end
      if nu
        res = yield
        return false if res == false
        if e.present?
          e.update_attribute :value,res
        else
          e = create cond.merge(:value=>res)
        end
      end
      # pp e
      e.val
    end
  end
end
