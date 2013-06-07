class TagQ
  @queue = 'tag'
  def self.perform method,*args
    Tag.send(method, *args)
  end
end
