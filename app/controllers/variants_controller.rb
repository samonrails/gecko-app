class VariantsController < ApplicationController
  def index
    @variants = access_token.get("/variants").parsed["variants"]
  end

  def show
    @variant = access_token.get("/variants/#{params[:id]}").parsed["variant"]
  end
end