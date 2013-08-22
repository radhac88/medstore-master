class StoreController < ApplicationController
 
before_filter :verify_user

  def verify_user
    if session[:user_id].nil? then
      redirect_to log_in_url, :notice=>"Please LoginIn/SignUp to continue"
    end
  end

  def index
  	@products = Product.all
  end
end
