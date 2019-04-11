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

  puts "\n\n"
  puts "Creating Email"
  Emails::Basic.create! title: "Welcome Pokemon Email",
    subject: "{{ pokemon.name | capitalize }}",
    include_predicate: "pokemon.name is present",
    body: <<BODY, css: <<CSS
<wrapper class="header">
  <container>
    <row class="collapse">
      <columns small="6">
        <img src="{{ pokemon.sprites.front_default }}">
      </columns>
      <columns small="6">
        <p class="text-right">
        {% for type in pokemon.types %}
          {{ type.type.name | capitalize }}
        {% endfor %}
        </p>
      </columns>
    </row>
  </container>
</wrapper>

<container>
  <spacer size="16"></spacer>
  <row>
    <columns small="12">
      <h1>Hi, {{ pokemon.name }}</h1>
      <p class="lead">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Magni, iste, amet consequatur a veniam.</p>
      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ut optio nulla et, fugiat. Maiores accusantium nostrum asperiores provident, quam modi ex inventore dolores id aspernatur architecto odio minima perferendis, explicabo. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Minima quos quasi itaque beatae natus fugit provident delectus, magnam laudantium odio corrupti sit quam. Optio aut ut repudiandae velit distinctio asperiores?</p>
      <callout class="primary">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Reprehenderit repellendus natus, sint ea optio dignissimos asperiores inventore a molestiae dolorum placeat repellat excepturi mollitia ducimus unde doloremque ad, alias eos!</p>
      </callout>
    </columns>
  </row>
  <wrapper class="secondary">
    <spacer size="16"></spacer>
    <row>
      <columns large="6">
        <h5>Connect With Us:</h5>
        <button class="facebook expand" href="http://zurb.com">Facebook</button>
        <button class="twitter expand" href="http://zurb.com">Twitter</button>
        <button class="google expand" href="http://zurb.com">Google+</button>
      </columns>
      <columns large="6">
        <h5>Contact Info:</h5>
        <p>Phone: 408-341-0600</p>
        <p>Email: <a href="mailto:foundation@zurb.com">foundation@zurb.com</a></p>
      </columns>
    </row>
  </wrapper>
</container>
BODY
.header {
  background: #8a8a8a;
}
.header .columns {
  padding-bottom: 0;
}
.header p {
  color: #fff;
  margin-bottom: 0;
}
.header .wrapper-inner {
  padding: 20px; /*controls the height of the header*/
}
.header .container {
  background: #8a8a8a;
}
.wrapper.secondary {
  background: #f3f3f3;
}
CSS

end
