# spec/controllers/admin/authentication_helper.rb

unless User.exists?(:email => "test@testificate.com")
  User.create(:email => "test@testificate.com", :password => "xyzzy", :password_confirmation => "xyzzy")
end # unless

shared_examples "requires authentication" do |controller, params = {}|
  %w(only except).each do |key|
    params[key.intern] = [params[key.intern]].flatten.compact.map(&:to_s).map(&:intern)
  end # each
  
  actions = { :create => :post, :destroy => :delete, :edit => :get,
    :index => :get, :new => :get, :show => :get, :update => :put }
  actions.keep_if { |action, method| params[:only].include? action } unless params[:only].empty?
  actions.keep_if { |action, method| !(params[:except].include? action) }
  
  actions.each do |action, method|
    it "#{method.upcase} :#{action} redirects to root" do
      self.send :"#{method}", :"#{action}"
      response.should redirect_to :root
    end # it ... redirects to root
  end # each
end # shared_examples requires authentication
