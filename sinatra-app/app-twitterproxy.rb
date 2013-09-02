# further requires (models, helpers, core extensions etc. { but not 'middleware' because that should be grabbed up by Rack when appropriate })
Dir.glob('./application/**/*.rb') do |file|
  require file.gsub(/\.rb/, '') unless file.include?('middleware')
end

require 'pp'
require 'json'
require 'date'
require 'sinatra/cross_origin'
require 'sinatra/reloader' if development?

require 'net/http'
require 'open-uri'
# -------------------------------------------------------------------


# --------------------------------------------------------------------

configure do
  enable :cross_origin
  set :protection, :except => :http_origin 
	set :allow_origin, "*"
	set :allow_methods, [:get, :post, :options]
	set :allow_credentials, true
	#set :max_age, "1728000"

	Twitter.configure do |config|
	  config.consumer_key = 'hZLqeeiA5KcdQw8bkPCTA'
	  config.consumer_secret = 'jWDo0nc1KYC13lTa8SMT20IohxUxJ2xh9M1qW3QcONk'
	  config.oauth_token = '17091428-yb2uEQrf10sGSi088pS2QZTVNOcc2XC3wBCfskftu'
	  config.oauth_token_secret = 'xmBWhcCVt4Z9zYPNkDMjDC8EdscCgZQUSKFiFnx7SI'
	end

end

#--------------------------------------------------------------


before do
  if request.request_method == "POST"
    body_parameters = request.body.read
    begin	
    	params.merge!(JSON.parse(body_parameters))
  	rescue
  		return true
  	end
  end
end

get '/' do

	Twitter.user_timeline("dtgallant").each do |tweet|
		puts "#{tweet.to_json}"
	end

	"testing twitter proxy endpoint"

end


get '/1.1/statuses/user_timeline.json' do
#get '/test' do

	screen_name = params[:screen_name]
	count = params[:count]
	include_rts= params[:include_rts]
	page = params[:page]
	include_entities = params[:include_entities]
	callback = params[:callback]

	begin

		tweets = []
		Twitter.user_timeline(screen_name, :count => count, :include_entities => include_entities,:page => page, :include_rts => include_rts).each do |tweet|		
			#puts "#{tweet.attrs.to_json}"
			tweets << tweet.attrs
		end

		json_result = tweets.to_json

		#cache the result as a json file
		File.open("public/json_results/user_timeline_#{screen_name}.json","w") do |f|
  			f.write(json_result)
		end

		return "#{callback}(#{json_result})"

	rescue Twitter::Error::TooManyRequests => error
  		#return result from the cache instead		
   		
		#attempt to retrieve cached json result
		begin
			json_store_result = File.read("public/json_results/user_timeline_#{screen_name}.json","r")
			return "#{callback}(#{json_store_result})"
		rescue
			#if the file doesn't exist, return empty result
			return "#{callback}({})"
		end   		

  	end

end

get '/1.1/search/tweets.json' do

	q = params[:q]
	include_entities = params[:include_entities]
	callback = params[:callback]

	begin

		tweets = []
		Twitter.search(q).results.each do |tweet|
			#puts "#{tweet.attrs.to_json}"
			tweets << tweet.attrs
		end

		json_result = tweets.to_json

		#cache the result as a json file
		File.open("public/json_results/twitter_search_#{q}.json","w") do |f|
  			f.write(json_result)
		end

		return "#{callback}(#{json_result})"

	rescue Twitter::Error::TooManyRequests => error
  		#return result from the cache instead		
   		
		#attempt to retrieve cached json result
		begin
			json_store_result = File.read("public/json_results/user_timeline_#{screen_name}.json","r")
			return "#{callback}(#{json_store_result})"
		rescue
			#if the file doesn't exist, return empty result
			return "#{callback}({})"
		end   		

  	end


end


def html_page(title, body)
    "<html>" +
        "<head><title>#{h title}</title></head>" +
        "<body><h1>#{h title}</h1>#{body}</body>" +
    "</html>"
end

helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

