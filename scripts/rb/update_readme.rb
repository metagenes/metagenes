# ./scripts/rb/update_readme.rb
require "json"
require "faraday"

# Get all posts
# Take a look how we obtain our secret key by using ENV[]
response = Faraday.get(
  "https://api.github.com/users/metagenes/repos?sort=updated&per_page=5"
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
Experienced Software Engineer with a focus on Laravel API development. I have experience building web applications with PHP using Laravel, CodeIgniter, and Lumen. 
Proficient in building complex RESTful APIs for integrating EKYC, OCR, Passive Liveness and various Bank Services with Laravel. Able to work independently and as part of a team, with good communication skills. 
I have a high learning spirit and always keep up with the latest technology developments. 

- 😄 Pronouns: He/Him
- 🌱 I’m currently learning Frontend using Vue 3 and ReactJS


![counter](https://ene3oosohyebu4a.m.pipedream.net)


## My last updated Repo:
#{posts.join}
EOF

# Write you markdown to README.MD
File.write("./README.md", markdown)
