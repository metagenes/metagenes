# ./scripts/rb/update_readme.rb
require "json"
require "faraday"

# Get alupdated posts
response = Faraday.get(
  "api.github.com/users/metagenes/repos?sort=updated&per_page=5"
)

# Retrieve `title`, `url`, and `description` and
# wrap it to markdown syntax

posts = JSON.parse(response.body).map do |article|
  <<~EOF
  
  [#{article['name']}](#{article['html_url']})
  #{article['description']}
  EOF
end


# Generate your own layout and paste posts in it
# Don't forget to change text and name =)
markdown = <<~EOF
### Hi there 👋

I like learning new things because I believe that as a software engineer you should keep learning new things and while also have some goal of what to achieve. After all, stacks that being used are always have something new to offer.

Fun facts, while I'm not crying doing coding I love listening to a podcast and baking or just messing with a recipe that  I found online



- 😄 Pronouns: He/Him
- 🌱 I’m currently learning DevOps

![counter](https://ene3oosohyebu4a.m.pipedream.net)

My last publications:
#{posts.join}

EOF

# Write you markdown to README.MD
File.write("./README.md", markdown)