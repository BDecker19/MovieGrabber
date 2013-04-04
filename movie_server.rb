require 'sinatra'

require_relative 'movies'

get '/' do
 	erb :index
end

post '/film_name' do
	# could redirect /:film_name?
	name = params[:film_name]
	m = Movie.get_film_info(name)
	erb :movie, :locals => {:film => m}
end