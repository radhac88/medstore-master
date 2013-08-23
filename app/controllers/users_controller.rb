class UsersController < ApplicationController
  
  before_filter :verify_user, :except=>"new"

  def verify_user
    if session[:user_id].nil? then
      redirect_to log_in_url, :notice=>"Please LoginIn/SignUp to continue"
    end
  end

  def new
  	@user=User.new
  end
  def create
  	@user=User.new(params[:user])
  	if @user.save
  		redirect_to log_in_url, :notice => "Login now to continue.."
  	else
  		render "new"
  end
  end
  def index
    @users = User.all
  end
  def destroy
    @user = User.find(params[:id])
    @user.delete

    redirect_to users_list_url

  end

end
