# spec/controllers/admin/categories_controller_spec.rb

require 'spec_helper'
require 'controllers/admin/authentication_helper'

describe Admin::CategoriesController do
  describe "routing", :type => :routing do
    it "GET /admin/categories is routable" do
      { :get => "/admin/categories" }.should be_routable
    end # ... is routable
    
    it "admin_categories_path is a named path" do
      { :get => admin_categories_path }.should route_to( :controller => "admin/categories", :action => "index" )
    end # it ... is a named path
  end # describe routing
  
  context "(authenticated)" do
    before :each do
      user = User.find_by_email("test@testificate.com")
      if user && user.authenticate("xyzzy")
        session[:user_id] = user.id
      else
        raise StandardError.new "unable to authenticate user \"test@testificate.com\" with password \"xyzzy\""
      end # if
    end # before :each
    
    after :each do
      session[:user_id] = nil
    end # before :each
    
    it "GET /admin/categories renders index" do
      get :index
      response.should render_template ["/admin/categories/index", "layouts/application"]
    end # it ... renders index
  end # context authenticated
  
  include_examples "requires authentication", :categories
end # describe Admin::CategoriesController
