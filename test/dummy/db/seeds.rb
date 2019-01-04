module RiddlerAdmin
  puts "Creating Step"
  step = Steps::Content.create! name: "User Research Prompt"

  puts "Creating Image"
  variant = Elements::Image.create! name: "image",
    text: "",
    href: "http://someimage",
    container: step

  puts "Creating Heading"
  Elements::Heading.create! name: "heading", text: "Do you have a few minutes?", container: step

  puts "Creating Variant"
  variant = Elements::Variant.create! name: "variant", container: step

    puts "  Creating Member Text"
    Elements::Heading.create! name: "text",
      text: "Hi {{ member.first_name }}, I'm Nicolina, a Product Designer at Nav. I'd love to hear your thoughts on our onboarding process.",
      container: variant,
      include_predicate: "member.first_name is present"

    puts "  Creating Business Text"
    Elements::Heading.create! name: "text",
      text: "Hi {{ account.business_name }}, I'm Nicolina, a Product Designer at Nav. I'd love to hear your thoughts on our onboarding process.",
      container: variant,
      include_predicate: "account.business_name is present"

    puts "  Creating Default Text"
    Elements::Heading.create! name: "text",
      text: "Hi, I'm Nicolina, a Product Designer at Nav. I'd love to hear your thoughts on our onboarding process.",
      container: variant

  puts "Creating Link"
  variant = Elements::Link.create! name: "link",
    text: "Earn $50 for 30 minutes of your time",
    href: "https://navsmb.typeform.com/to/Mya2il",
    container: step
end
