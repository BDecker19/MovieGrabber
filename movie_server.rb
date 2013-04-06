require 'sinatra'
require 'pry'
require 'rack-flash'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'
require 'colored'

require_relative 'movies'

enable :sessions
use Rack::Flash


# before '/search_page' do
#   unless params[:password] == "l"
#     flash[:notice] = "Sorry, please enter correct password to access site!"
#     redirect '/'
#   end
# end

get '/' do
  erb :search_page
end

post '/search_page' do
 	erb :search_page
end

post '/film_name' do
	# could redirect /:film_name and list out title?
    db_address = "films.db"
    m = Movie.new

  # open database assuming it exists.  
  unless File.exists?(db_address) == false
    db = SQLite3::Database.open db_address
  else  #create one!
    db = SQLite3::Database.new db_address
    db.execute("CREATE TABLE movies(Title varchar, Year varchar, Rating varchar, Genre varchar, Director varchar, Actors varchar, Plot varchar, Poster_url varchar)")
  end

  # check if film exists in database (will be false if database just created)
  m.pull_data(params[:film_name])
  name = m.retrieved_data["Title"]
  
  db.results_as_hash = true # necessary for loading into object
  search_result = db.execute("select * from movies where title = '#{name}'")
  db.close


  if search_result.length == 0
    puts "setting".red
    m.set_info
    m.add_to_DB(db_address)
  elsif search_result.length == 1
    puts "loading".blue
    m.load_from_DB(search_result)
  else
    puts "error -- other case need to deal with!".red  #should be some sort of raise error condition?
  end

  #load page!
  erb :movie, :locals => {:film => m}

end




