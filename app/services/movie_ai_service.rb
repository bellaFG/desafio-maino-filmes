require "net/http"
require "json"

class MovieAiService
  def self.fetch_data(title)
    key = ENV["OMDB_API_KEY"]
    url = "https://www.omdbapi.com/?t=#{URI.encode_www_form_component(title)}&apikey=#{key}"
    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)
    puts url
    puts data
    return nil unless data["Response"] == "True"

    {
      title: data["Title"],
      synopsis: data["Plot"],
      year: data["Year"],
      duration: data["Runtime"].to_i,
      director: data["Director"]
    }
  end
end
