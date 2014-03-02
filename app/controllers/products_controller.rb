class ProductsController < ApplicationController
  def index
    if access_token
      @products = access_token.get("/orders").parsed["orders"] 
    end
  end

  def show
    @product = access_token.get("/products/#{params[:id]}").parsed["product"]
    Trademe.fetch(current_user)
  end

  def new
    consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], {:site => "https://secure.trademe.co.nz",
    :request_token_path => "/Oauth/RequestToken" ,:access_token_path => "/Oauth/AccessToken",:authorize_path => "/Oauth/Authorize"})
    session[:request_token] = request_token = consumer.get_request_token
    @url =  request_token.authorize_url
    
  end

  def create
    if access_token
      verifier = params[:name]
      request_token = session[:request_token]
      access_token= request_token.get_access_token(:oauth_verifier => verifier)
      tm_creds = current_user.build_trademe_cred(:token => access_token.token, :token_secret => @access_token.secret)
      tm_creds.save
      redirect_to root_url
    else
      redirect_to :back
    end
    
  end
end
