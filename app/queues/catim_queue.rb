class CatimQueue
  @queue = :catim
  def self.perform parent_cid,parent_id
    keep_time 0.6 do
      api =  TaobaoFu::Api.new
      rs = api.itemcats_get(parent_cid)
      return false if rs.nil?
      rs.each do |r|
        c = Category.where(:cid=>r["cid"]).first_or_initialize(r)
        if c.new_record?
          c.parent_id = parent_id
          c.save
        else
          c.update_attributes r
        end
        Category.async_import(c.cid,c.id) if c.is_parent? 
      end
    end
  end
end
