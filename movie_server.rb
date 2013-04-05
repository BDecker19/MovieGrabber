require 'sinatra'
require 'pry'
require 'rack-flash'
require "sinatra"
require "sinatra/reloader" 

require_relative 'movies'

enable :sessions
use Rack::Flash

before '/search_page' do
  unless params[:password] == "coolbeans"
    flash[:notice] = "Sorry, please enter correct password to access site!"
    redirect '/landing'
  end
end

get '/' do
 	erb :landing
end

get '/landing' do
 	erb :landing
end

post '/search_page' do
 	erb :search_page
end

post '/film_name' do
	# could redirect /:film_name?
	name = params[:film_name]
	m = Movie.get_film_info(name)
	erb :movie, :locals => {:film => m}
end



# working on filn entry validation
# post '/film_name' do
# 	# could redirect /:film_name?
# 	name = params[:film_name]
# 	m = Movie.get_film_info(name)
# 	unless m
# 		erb :movie, :locals => {:film => m}
# 	else
# 		puts "doing this ish"
# 		flash[:notice] = "Please enter a name!"
# 		redirect '/'
# 	end
# end