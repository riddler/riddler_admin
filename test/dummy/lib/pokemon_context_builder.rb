require "net/http"
require "json"

class PokemonContextBuilder < ::Riddler::ContextBuilder
  def process
    return if context.params.pokemon_id.blank?

    uri = URI "https://pokeapi.co/api/v2/pokemon/#{context.params.pokemon_id}/"
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request
    parsed_response = JSON.parse response.body

    context.assign "pokemon", parsed_response
  end
end
