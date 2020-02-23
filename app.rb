require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# Don't forget attribution to Dark Sky and newsapi on site!

# enter your Dark Sky API key here
ForecastIO.api_key = "02dbcee29621252b05da7abab52d2a8e"

#Enter NewsApi here
news_apikey = "81c2dc01131a474c806f57e65cf445be"

get "/" do
    view "ask_location"
end

get "/news" do
    @location = params["LocationInputBox"]
    @location = @location.capitalize

    @geocoder_results = Geocoder.search(@location)
    @lat_long = @geocoder_results.first.coordinates # => [lat, long] array
    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash
    #"#{@forecast}"
    @url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=#{news_apikey}"
    @news = HTTParty.get(@url).parsed_response.to_hash
    
    #pp @news
    view "news"
    
end