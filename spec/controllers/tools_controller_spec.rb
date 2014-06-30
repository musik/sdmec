require 'spec_helper'

describe ToolsController do

  describe "GET 'xiaoliang'" do
    it "returns http success" do
      get 'xiaoliang'
      response.should be_success
    end
  end

end
