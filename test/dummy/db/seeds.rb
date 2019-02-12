module RiddlerAdmin
  puts "Creating Admin User"
  ::User.create! name: "Admin User", role: "admin"

  puts "Creating User"
  ::User.create! name: "User", role: "user"

  puts "Creating Blank Preview Context"
  pctx = PreviewContext.create! id: "pctx_blank", title: "Blank"
  pctx.refresh_data

  puts "=" * 80
  puts "Creating Pokemon Step"
  step = Steps::Content.create! id: "st_pokemon",
    title: "Pokemon",
    name: "pokemon",
    preview_enabled: true,
    include_predicate: "pokemon.name is present"

  puts "Creating Heading"
  Elements::Heading.create! name: "heading", text: "{{ pokemon.name | capitalize }}", container: step

  puts "Creating Text"
  Elements::Text.create! name: "text",
    text: "Height: {{ pokemon.height }} Weight: {{ pokemon.weight }}
Types: {% for type in pokemon.types %}
  {{ type.type.name | capitalize }}
{% endfor %}",
    container: step

  puts "Creating Image"
  Elements::Image.create! name: "image",
    url: "{{ pokemon.sprites.front_default }}",
    text: "{{ pokemon.name | capitalize }}",
    container: step

  puts "Creating Link"
  Elements::Link.create! name: "link",
    url: "https://pokeapi.co/api/v2/pokemon/{{ pokemon.id }}/",
    text: "View raw JSON from PokeAPI",
    container: step

  %w[ 1 2 25 100 ].each do |id|
    puts "Creating Pokemon Preview Context #{id}"
    pctx = PreviewContext.create! id: "pctx_pokemon#{id}", title: "Pokemon[#{id}]", params: "pokemon_id: #{id}"
    pctx.refresh_data
  end
end
