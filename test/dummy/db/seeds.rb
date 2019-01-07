module RiddlerAdmin
  puts "Creating Step"
  step = Steps::Content.create! id: "st_prompt", name: "User Research Prompt", preview_enabled: true

  puts "Creating Image"
  variant = Elements::Image.create! name: "image",
    text: "Nicolina",
    href: "https://cdn.nav.com/wp-content/uploads/2017/10/nicolina_brown.jpg",
    container: step

  puts "Creating Heading"
  Elements::Heading.create! name: "heading", text: "Do you have a few minutes?", container: step

  puts "Creating Variant"
  variant = Elements::Variant.create! name: "variant", container: step

    puts "  Creating Member Text"
    Elements::Text.create! name: "text",
      text: "Hi {{ member.first_name }}, I'm Nicolina, a Product Designer at Nav. I'd love to hear your thoughts on our onboarding process.",
      container: variant,
      include_predicate: "member.first_name is present"

    puts "  Creating Business Text"
    Elements::Text.create! name: "text",
      text: "Hey owner of {{ enterprise_business.name }}, I'm Nicolina, a Product Designer at Nav. I'd love to hear your thoughts on our onboarding process.",
      container: variant,
      include_predicate: "enterprise_business.name is present"

    puts "  Creating Default Text"
    Elements::Text.create! name: "text",
      text: "Hi, I'm Nicolina, a Product Designer at Nav. I'd love to hear your thoughts on our onboarding process.",
      container: variant

  puts "Creating Link"
  variant = Elements::Link.create! name: "link",
    text: "Earn $50 for 30 minutes of your time",
    href: "https://navsmb.typeform.com/to/Mya2il",
    container: step



  puts "=" * 80
  puts "Creating Pokemon Step"
  step = Steps::Content.create! id: "st_pokemon", name: "Pokemon", preview_enabled: true

  puts "Creating Heading"
  Elements::Heading.create! name: "heading", text: "{{ pokemon.name | capitalize }}", container: step

  puts "Creating Text"
  Elements::Text.create! name: "text",
    text: "Height: {{ pokemon.height }} Weight: {{ pokemon.weight }}
Types: {% for type in pokemon.types %}
  {{ type.type.name | capitalize }}
{% endfor %}"
    container: step

  %w[ 1 2 3 ].each do |id|
    puts "Creating Pokemon Preview Context #{id}"
    pctx = PreviewContext.create! id: "pctx_pokemon#{id}", title: "Pokemon[#{id}]", params: "pokemon_id: #{id}"
    pctx.refresh_data
  end
end
