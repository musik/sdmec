require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe FenleisController do

  # This should return the minimal set of attributes required to create a valid
  # Fenlei. As you add validations to Fenlei, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FenleisController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all fenleis as @fenleis" do
      fenlei = Fenlei.create! valid_attributes
      get :index, {}, valid_session
      assigns(:fenleis).should eq([fenlei])
    end
  end

  describe "GET show" do
    it "assigns the requested fenlei as @fenlei" do
      fenlei = Fenlei.create! valid_attributes
      get :show, {:id => fenlei.to_param}, valid_session
      assigns(:fenlei).should eq(fenlei)
    end
  end

  describe "GET new" do
    it "assigns a new fenlei as @fenlei" do
      get :new, {}, valid_session
      assigns(:fenlei).should be_a_new(Fenlei)
    end
  end

  describe "GET edit" do
    it "assigns the requested fenlei as @fenlei" do
      fenlei = Fenlei.create! valid_attributes
      get :edit, {:id => fenlei.to_param}, valid_session
      assigns(:fenlei).should eq(fenlei)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Fenlei" do
        expect {
          post :create, {:fenlei => valid_attributes}, valid_session
        }.to change(Fenlei, :count).by(1)
      end

      it "assigns a newly created fenlei as @fenlei" do
        post :create, {:fenlei => valid_attributes}, valid_session
        assigns(:fenlei).should be_a(Fenlei)
        assigns(:fenlei).should be_persisted
      end

      it "redirects to the created fenlei" do
        post :create, {:fenlei => valid_attributes}, valid_session
        response.should redirect_to(Fenlei.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved fenlei as @fenlei" do
        # Trigger the behavior that occurs when invalid params are submitted
        Fenlei.any_instance.stub(:save).and_return(false)
        post :create, {:fenlei => { "name" => "invalid value" }}, valid_session
        assigns(:fenlei).should be_a_new(Fenlei)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Fenlei.any_instance.stub(:save).and_return(false)
        post :create, {:fenlei => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested fenlei" do
        fenlei = Fenlei.create! valid_attributes
        # Assuming there are no other fenleis in the database, this
        # specifies that the Fenlei created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Fenlei.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => fenlei.to_param, :fenlei => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested fenlei as @fenlei" do
        fenlei = Fenlei.create! valid_attributes
        put :update, {:id => fenlei.to_param, :fenlei => valid_attributes}, valid_session
        assigns(:fenlei).should eq(fenlei)
      end

      it "redirects to the fenlei" do
        fenlei = Fenlei.create! valid_attributes
        put :update, {:id => fenlei.to_param, :fenlei => valid_attributes}, valid_session
        response.should redirect_to(fenlei)
      end
    end

    describe "with invalid params" do
      it "assigns the fenlei as @fenlei" do
        fenlei = Fenlei.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Fenlei.any_instance.stub(:save).and_return(false)
        put :update, {:id => fenlei.to_param, :fenlei => { "name" => "invalid value" }}, valid_session
        assigns(:fenlei).should eq(fenlei)
      end

      it "re-renders the 'edit' template" do
        fenlei = Fenlei.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Fenlei.any_instance.stub(:save).and_return(false)
        put :update, {:id => fenlei.to_param, :fenlei => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested fenlei" do
      fenlei = Fenlei.create! valid_attributes
      expect {
        delete :destroy, {:id => fenlei.to_param}, valid_session
      }.to change(Fenlei, :count).by(-1)
    end

    it "redirects to the fenleis list" do
      fenlei = Fenlei.create! valid_attributes
      delete :destroy, {:id => fenlei.to_param}, valid_session
      response.should redirect_to(fenleis_url)
    end
  end

end