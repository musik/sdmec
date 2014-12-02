#encoding: utf-8
class Entry < ActiveRecord::Base
  include ActiveModel::Validations

  class LinkValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add attribute, "没有找到链接" unless record.check_link
    end
  end
  attr_accessible :clicked_at, :link_checked_at, :link_status, :name, :pwd, :qq, :url,:description,:keywords,:content
  validates :url,presence: true,format: {with: /^http:\/\/([a-z0-9\-\.]+)\/*$/i},uniqueness: true,on: :create
  validates :name,presence: true,uniqueness: true
  #validates :pwd,presence: true
  validates :link_status,link: true,on: :create
  validates :content,presence: true,length: {minimum: 50}
  #validates :description,presence: true,length: {maximum: 200}

  scope :recent_click,->{where(link_status: true).order("clicked_at desc")}
  belongs_to :user,counter_cache: true
  def check_link update_clicked_at = true
    begin
      data = open(url).read
    rescue 
      return false
    end
    patt = Regexp.new('<a.+?href=["\']*http://www.sdmec.com/*["\']*')
    self[:link_status] = data.match(patt).present? ? true : false
    self[:link_checked_at] = Time.now
    self[:clicked_at] = Time.now if update_clicked_at
    self[:link_status]
  end
  before_validation :clean_url
  def clean_url
    self[:url] = self[:url][0,self[:url].length-1] if self[:url][-1] == "/"
    self[:keywords].gsub!(/，/,',') if self[:keywords].present?
  end
  def to_param
    url.sub('http://','')
  end
  def self.find_by_host host
    where(url: "http://#{host}").first
  end
end
