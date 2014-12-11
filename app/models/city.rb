# -*- encoding : utf-8 -*-
class City < ActiveRecord::Base
  #attr_accessible :name, :slug, :parent_id, :use_subdomain, :zhixiashi
  attr_accessor :count
  acts_as_url :name,:url_attribute=>:slug,:only_when_blank=>true
  scope :roots,where(:parent_id=>0)
  has_many :stores
  has_many :posts
  def to_param
    slug
  end
  def siblings
    City.where(:parent_id=>parent_id).all.delete_if{|r| r.id == id}
  end
  def children
    if parent_id == 0
      return City.where(:parent_id=>id).all  
    end
    nil
  end
  def parent 
    @parent ||= parent_id.zero? ? nil : City.find(parent_id) 
  end
  def children_or_siblings
    if parent_id == 0 and !zhixiashi?
      return City.select([:name,:slug]).where(:parent_id=>id).all
    else
      City.select([:name,:slug]).where(:parent_id=>parent_id).all.delete_if{|r| r.slug == slug}  
    end
  end  
  class << self
    def others topic,n=20,city_id=nil
      Rails.cache.fetch ["others",topic.id,n,city_id],:expires_in=>5.days do
        # if topic.id.present?
          # # joins("left join cts on cts.topic_id = #{topic.id} and cts.city_id = cities.id").order("cts.items_count desc").limit(n)
          # ids = Ct.select(:city_id).where(:topic_id=>topic.id).order("items_count desc").limit(n).collect{|ct| ct.city_id}
          # ids.delete city_id
          # # logger.info ids
          # rs = ids.present? ? where(:id=>ids).all : nil
        # end
        # rs.nil? ? where(:parent_id=>0).limit(n).all : rs
        cond = city_id.nil? ? nil : "id != #{city_id}"
        where(cond).random(n)
      end
    end
    def random(i)
      c = count + 1 - i
      c = 0 if c < 0
      limit(i).offset(rand(c)).all
    end
    def init_level
      City.where(:parent_id=>0).update_all :level=>0
      City.where(:parent_id=>0).each do |c|
        City.where(:parent_id=>c.id).update_all :level=>4
        City.where(:parent_id=>c.id).limit(5).update_all :level=>3
        City.where(:parent_id=>c.id).limit(1).update_all :level=>1
      end

    end
    def tree
      #Rails.cache.fetch "model-city-tree" do
        rs = self.all
        ns={
          :zhixiashi => [],
          :parents => [],
          :children => {}
        }
        rs.each do |r|
          if r.zhixiashi?
            ns[:zhixiashi] << r
          elsif r.parent_id.zero?
            ns[:parents] << r
          else
            ns[:children][r.parent_id] = [] unless ns[:children].has_key? r.parent_id
            ns[:children][r.parent_id] << r 
          end
        end
        ns
      #end 
    end
    def cached_roots
      Rails.cache.fetch "model-city-roots" do
        City.roots
      end
    end
    def caps
      Rails.cache.fetch "city-caps-20121221-0" do
        select(%w(name slug)).where(:name=>%w(北京 上海 天津 重庆 哈尔滨 长春 沈阳 呼和浩特 石家庄 乌鲁木齐 兰州 西宁 西安 银川 郑州 济南 太原 合肥 武汉 长沙 南京 成都 贵阳 昆明 南宁 拉萨 杭州 南昌 广州 福州 厦门 常州 大连 新疆 邯郸 无锡 苏州 青岛 深圳)).all
      end
    end
  end
end
