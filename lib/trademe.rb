require 'rubygems'
require 'net/http'

class Trademe
  def self.setup_token
    @consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], {:site => "https://secure.trademe.co.nz",
    :request_token_path => "/Oauth/RequestToken" ,:access_token_path => "/Oauth/AccessToken",:authorize_path => "/Oauth/Authorize"})
    @request_token = @consumer.get_request_token
    puts "Visit the following URL, log in if you need to, and authorize the app"
    puts @request_token.authorize_url
    puts "When you've authorized that token, enter the verifier code you are assigned:"
    verifier = gets.strip
    @access_token=@request_token.get_access_token(:oauth_verifier => verifier) 
    auth = {}
    auth["token"] = @access_token.token
    auth["token_secret"] = @access_token.secret
    File.open('trademe.yaml', 'w') {|f| YAML.dump(auth, f)}
  end
  def self.fetch
    time = ENV["TIME"]
    @consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], { :site => "https://secure.trademe.co.nz"})
    auth = YAML.load(File.open('trademe.yaml'))
    @access_token = OAuth::AccessToken.new(@consumer, auth["token"], auth["token_secret"])
    oauth_client = OAuth2::Client.new(ENV["OAUTH_ID"], ENV["OAUTH_SECRET"], site: "https://api.tradegecko.com")
    ref_tok = YAML.load(File.open('tradegecko.yaml'))
    data = { :client_id => ENV["OAUTH_ID"],:client_secret => ENV["OAUTH_SECRET"], :redirect_uri=> "http://sgupta01.pagekite.me/auth/tradegecko/callback",:refresh_token => ref_tok[:refresh_token],:grant_type => "refresh_token"}
    tok = OAuth2::AccessToken.from_hash(oauth_client, data)
    token = tok.refresh!
    a_token = {:access_token => token.token, :refresh_token => token.refresh_token, :expires_at => token.expires_at}
    File.open('tradegecko.yaml', 'w') {|f| YAML.dump(a_token, f)}
    res = ::JSON.parse(@access_token.get("https://api.trademe.co.nz/v1/MyTradeMe/SoldItems/#{time}.json").body)
    listing = res["List"]
    puts "Total orders fetch #{listing.count}"
    listing.each do |list|
      listing = Listing.new(:order => list["ListingId"])
      if listing.save
        address = token.post("/addresses", params: {address: {:address1 => list["DeliveryAddress"]["Address1"], :address2 => list["DeliveryAddress"]["Address2"],
        :city => list["DeliveryAddress"]["City"], :country => list["DeliveryAddress"]["Country"], :suburb => list["DeliveryAddress"]["Suburb"],
        :zip_code => list["DeliveryAddress"]["Postcode"], :phone_number => list["DeliveryAddress"]["PhoneNumber"], :company_id => ENV["COMPANY_ID"], :label => "Shipping"}})
        address_id =  ::JSON.parse(address.body)['address']['id']
        order = token.post('/orders', params: { order:{:shipping_address_id => address_id, :company_id => ENV["COMPANY_ID"],
                :email => list["Buyer"]["Email"], :order_number =>list["ReferenceNumber"], :issued_at => Time.now,
                :phone_number => list["DeliveryAddress"]["PhoneNumber"], :due_at =>Time.now, :issued_at => Time.now,
                }})
      end
    end
  end
end