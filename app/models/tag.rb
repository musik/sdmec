class Tag < ActsAsTaggableOn::Tag
  include ResqueEx
  @queue = "tag"
  def autotag
    Store.where("title like ?","%#{name}%").find_each do |s|
      #async 'add_to_store',s.id
      Resque.enqueue(TagQ,'set_store_tag', id, s.id)
    end
  end
  def async_autotag
    async 'autotag'
  end
  def add_to_store store_id,tagger_id=nil,context='tags'
    ActsAsTaggableOn::Tagging.create(:tag_id=>id,:taggable_id=>store_id,:taggable_type=>'Store',:context=>context,:tagger_id=>tagger_id)
  end
  def self.find_or_create_all_with_like_by_name(*list)
    list = [list].flatten
    return [] if list.empty?
    existing_tags = Tag.named_any(list)
    list.map do |tag_name|
      comparable_tag_name = comparable_name(tag_name)
      existing_tag = existing_tags.find { |tag| comparable_name(tag.name) == comparable_tag_name }
      existing_tag || Tag.create(:name => tag_name)
    end
  end  
  def self.set_store_tag id,store_id,tagger_id=nil,context='tags'
    ActsAsTaggableOn::Tagging.create(:tag_id=>id,:taggable_id=>store_id,:taggable_type=>'Store',:context=>context,:tagger_id=>tagger_id)
  end
  class << self
    def all_tagged_on taggable_type,context='tags'
      joins(:taggings).where('taggings.taggable_type'=>taggable_type.classify).group('tags.id').select('tags.*,count(*) as count')
    end
  end
end
module TagEx
  def to_param
    CGI.escape(name)
  end
end
ActsAsTaggableOn::Tag.send :include,TagEx
