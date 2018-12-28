class PokemonDrop < ::Liquid::Drop
  attr_reader :response

  def initialize response
    @response = response
  end

  def id
    data["id"]
  end

  def name
    data["name"]
  end

  def height
    data["height"]
  end

  def weight
    data["weight"]
  end

  def sprite
    data.dig "sprites", "front_default"
  end

  private

  def data
    response.body
  end
end
