#encoding: utf-8
require 'spec_helper'

describe Tag do
  it "should create" do
    #tags = Tag.find_or_create_all_with_like_by_name ['女装','童装']
    #pp tags
    #tags.map(&:autotag)
    ##pp Tag.where(:id=>tags.map(&:id))

    #Store.create :title=>"女装"
    #tags.first.autotag
    #for i in 1..2 do
      #Store.create :title=>"#{i}女装"
      #Store.create :title=>"#{i*2}童装"
    #end
    ##Tag.all.each do |t|
      ##t.autotag
    ##end
    #Tag.first.add_to_store Store.first.id
  end
end
