class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  #add_breadcrumb "Home", "/products/home"
  http_basic_authenticate_with :name=>"admin", :password=>"admin"
  add_breadcrumb "Browse products", "/products", except: [:home,:reports,:welcome,:index]
  add_breadcrumb "New Product", "/products/new", only: [:new, :create]
  add_breadcrumb "Edit Product", "/products/edit", only: [:edit]
  add_breadcrumb "Product","", only: [:show]
 # add_breadcrumb "Search Results", "/products/search_results", only: [:search_results]

  before_filter :verify_user, :except=>"home"

  def verify_user
    if session[:user_id].nil? then
      redirect_to log_in_url, :notice=>"Please LoginIn/SignUp to continue"
    end
  end

  require 'date'
  def welcome
  end
  def reports
    a = Date.today
    @products = Product.all
    @exproduct = Product.where("expired_on < ?", a+30)
  end
    

  def home
    a = Date.today
    
    @products=Product.all

    @i=0
    @exproduct = Product.where("expired_on < ?", a+300)
    
    #@rd = params[:product] && params[:product][:expired_on]
    #@remain_days = params[:product][:expired_on]
    @vendors = Vendor.all

    require "rubygems"
    require "twitter"
    Twitter.configure do |config|
      config.consumer_key = 'YKUYyQRL1n6NygTJg499RA'
      config.consumer_secret =  'ScgsEd17Zi1EPP5dAClETh54bPZ8RQlObthHbVmqBM'
      config.oauth_token = '401513252-UyYoT9fnFqolfhXSLK7Q46FOF0NFrpoGiJZYfdCK'
      config.oauth_token_secret = 'LOYXUvWTwA8blVK3yXszQyFUOBjPNu48PVskzXCg'
    end
     client = Twitter::Client.new
     @troy = Twitter.user_timeline("ncbn").first.text
     @troyy = Twitter.user_timeline("ncbn").second.text
     @troyyy = Twitter.user_timeline("ncbn").third.text
  end
  def index
    @products = Product.all
    @products = Product.order("id").page(params[:page]).per(5)
    @vendors = Vendor.all
    #@vendors = Vendor.find(params[:id])

    # q = Product.where(params[:product_name])
    # #q = params[:product][:product_name]
    #   @search_results = Product.find(:all, :conditions => ['product_name LIKE ?', "%#{q}%"]) 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  def search_results

    q = params[:product][:product_name]
    @search_results = Product.find(:all, :conditions => ['product_name LIKE ?', "%#{q}%"])
  
  end
  # GET /products/1
  # GET /products/1.json
  def show
    
    @product = Product.find(params[:id])
    @vendors = @product.vendor(:all)
    #@vendors = Vendor.find(params[:id])
    #@vendors = Vendor.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
 
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])
    #@product = Product.create(vendor_id: @vendor.id)
    #@vendor = Vendor.all
    #@product = @vendor.products.create(product_date :Time.now, vendor_id: @vendor.id)
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
  

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.delete

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
      format.js { render :layout => false }
    end
    end
    def delete_product
     #Product.destroy(params[:product])
     #@product = Product.where(params[:id])
     #@product = Product.all
     #@product.delete(params[:product_id])
     begin
        @products = Product.find(params[:product_ids])
     rescue ActiveRecord::RecordNotFound
        logger.error "No products selected to delete"
        redirect_to products_url, :notice=> "Please select products to delete!!"
      else
     @products.each do |product|    
     product.delete
     flash[:alert] = "Selected products deleted successfully.."
     end

     respond_to do |format|
        format.html {redirect_to products_url}
     end
   end
    end
end
