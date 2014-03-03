class ProductsController < ApplicationController
  def index
    @products = access_token.get("/orders").parsed["orders"] if access_token
  end

  def show
    Trademe.fetch(current_user) if access_token
    @product = {} 
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
      tm_creds = current_user.trademe_cred
      if tm_creds
        tm_creds.token = access_token.token
        tm_creds.token_secret = access_token.secret
      else
        tm_creds = current_user.build_trademe_cred(:token => access_token.token, :token_secret => access_token.secret)
      end
      tm_creds.save
      redirect_to root_url
    else
      redirect_to :back
    end
  end

end
