# -*- encoding : utf-8 -*-
class Kts
  class << self
    def db_init
      @kt ||= KyotoTycoon.new('localhost', 1978)
    end
  
    def test
      db_init
      # traditional style
      @kt.set('foo', 123, 1)
      p eval(@kt.get('foo')) # => "123".  carefully, it is String, not Integer, by default
      sleep 2
      p @kt.get('foo')
      # Ruby's hash style
      @kt['bar'] = 42
      p @kt['bar'] # => "42".
      @kt.set :bar,[:arf]
      p @kt.get(:bar)[0]
      @kt.delete(:foo)
    end
    def get key
      db_init
      e = @kt.get(key)
      (e.present? and %w([ {).include?(e[0,1])) ? eval(e) : e
    end
    def write key,&block
      db_init
      res = yield
      return false if res == false
      @kt.set key,res
    end
    def fetch key,options={},&block
      db_init
      defaults = {
        :force => false,
        :expires_in => nil
      }
      options= defaults.merge! options 
      
      e = @kt.get(key)
      
      nu = false #need update 
      if e.present?
        nu = true if options[:force] != false 
      else
       nu = true
      end
      if nu
        res = yield
        return false if res == false
        @kt.set key,res,options[:expires_in].to_i
        return res
      end
      e = @kt.get(key)
      %w([ {).include?(e[0,1]) ? eval(e) : e 
    end
  end
end
