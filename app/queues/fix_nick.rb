class FixNick
  @queue = :fix_nick
  def self.perform id
    Store.find(id).fix_nick 
  end
end
