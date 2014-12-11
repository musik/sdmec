class Searched < Ohm::Model
  attribute :query
  attribute :created_at
  class << self  
    def recent n=10
      all.sort(:limit=>[all.size-50,50],:get=>'query').uniq.reverse.slice(0,n)
    end
    def page num,per
      all.sort(:limit=>[num*per-per,per],:get=>'query').reverse.uniq
    end
  end
end
