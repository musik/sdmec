# -*- encoding : utf-8 -*-
require 'pp'
class ImportWords
  def from_csv
    file = "#{Rails.root}/tmp/5w.csv"
    lines = File.readlines(file)
    keys = lines.shift.strip.split('|')
    # pp keys
    i = 0
    lines.each do |l|
      arr = l.strip.split('|')
      data = {}
      data[:volume] = parse_price arr[5]
      name = (arr[3] =~ / /).nil? ? arr[3] : parse_word(arr[3])
      next if name == "/"
      
      # pp data  
      # i+=1  
      # break if i >50
      
      name = parse_multi_word(name) if name =~ /\//
     
     if name.is_a? Array
       name.each do |str|
         Topic.where(:name=>str).first_or_create(data)
       end
     else
       Topic.where(:name=>name).first_or_create(data)
     end
    end
  end
  def parse_price str
    return 50 if str == '100以下'
    min,max = str.split('-')
    ((min.to_i+max.to_i)/2).to_i
  end
  def parse_word str
    str.gsub(/([^\w\d]) /,'\1').gsub(/ ([^\w\d])/,'\1') 
  end
  def parse_multi_word str
    if (str =~ /[\w\d]/).nil?
      str.split('/').uniq
    else
      arr = str.scan(/^(.+?)\/(.+)$/)[0]
      str = arr[1] if (arr[1] =~ Regexp.new("^#{arr[0]}")).present?
      str
    end
  end
end
