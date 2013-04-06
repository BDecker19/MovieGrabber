require 'httparty'
require 'json'

class Movie

  # Add attr_accessors for the values you want to store... (:retreived_data = stored full data hash. avoids having to make second call)
  attr_accessor :title, :year, :rating, :genre, :director, :actors, :plot, :poster_url, :retrieved_data 

  def exists_in_DB? (name, db_address)
    db = SQLite3::Database.open db_address
    search_result = db.execute("select * from movies where title = '#{name}'")
    db.close
    if search_result.length == 0
      return false
    elsif search_result.length == 1
      return true
    else
      puts "error -- other case need to deal with!"  #should be some sort of raise error condition?
    end
  end

  def pull_data(input)  
    input_mod = input.gsub(" ", "%20")
    imdb_data = HTTParty.get("http://www.omdbapi.com/?t=#{input_mod}")
    @retrieved_data = JSON(imdb_data)
  end

  def set_info    
    @title = @retrieved_data["Title"]
    @year = @retrieved_data["Year"]
    @rating = @retrieved_data["Rated"]
    @genre = @retrieved_data["Genre"]
    @director = @retrieved_data["Director"]
    @actors = @retrieved_data["Actors"]
    @plot = @retrieved_data["Plot"]
    @poster_url = @retrieved_data["Poster"]
  end

  def add_to_DB(db_address)
    db = SQLite3::Database.open db_address
    sql = "insert into movies (Title, Year, Rating, Genre, Director, Actors, Plot, Poster_url) values (?, ?, ?, ?, ?, ?, ?, ?)"
    db.execute(sql, @title, @year, @rating, @genre, @director, @actors, @plot, @poster_url)
    db.close
  end

  def load_from_DB(info_hash)
    @title = info_hash[0]["Title"]
    @year = info_hash[0]["Year"]
    @rating = info_hash[0]["Rated"]
    @genre = info_hash[0]["Genre"]
    @director = info_hash[0]["Director"]
    @actors = info_hash[0]["Actors"]
    @plot = info_hash[0]["Plot"]
    @poster_url = info_hash[0]["Poster_url"]
  end

end