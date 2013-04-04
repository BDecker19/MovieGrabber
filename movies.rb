require 'httparty'
require 'json'
require 'pry'

class Movie

  # Add attr_accessors for the values you want to store...
  attr_accessor :title, :year, :rating, :genre, :director, :actors, :plot, :poster_url

  def self.get_film_info(name)    
    imdb_data = HTTParty.get("http://www.omdbapi.com/?t=#{name}")
    movie_info = JSON(imdb_data)

    # Create a Movie object...
    m = Movie.new
    m.title = movie_info["Title"]
    m.year = movie_info["Year"]
    m.rating = movie_info["Rated"]
    m.genre = movie_info["Genre"]
    m.director = movie_info["Director"]
    m.actors = movie_info["Actors"].split(",")
    m.plot = movie_info["Plot"]
    m.poster_url = movie_info["Poster"]
    m
  end

end