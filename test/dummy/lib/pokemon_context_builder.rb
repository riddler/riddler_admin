require "faraday"

class PokemonContextBuilder < ::Riddler::ContextBuilder
  def process
    return unless context.params.pokemon_id
    pokemon_id = context.params.pokemon_id
    response = connection.get "/api/v2/pokemon/#{pokemon_id}/"

    context.assign "pokemon", PokemonDrop.new(response)
  end

  private

  def connection
    Faraday.new url: "https://pokeapi.co" do |conn|
      conn.adapter Faraday.default_adapter
      conn.response :json, :content_type => /\bjson$/
    end
  end
end
