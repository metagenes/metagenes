# ./scripts/rb/update_readme.rb
require "json"
require "faraday"

# Get all posts
# Take a look how we obtain our secret key by using ENV[]
response = Faraday.get(
  "https://api.github.com/users/metagenes/repos?sort=updated&per_page=5"
)

# Retrieve `name`, `url`, and `description` and
# wrap it to markdown syntax
posts = JSON.parse(response.body).map do |article|
  description = article["description"]&.strip
  description = "No description available." if description.nil? || description.empty?

  "- [#{article['name']}](#{article['html_url']}) — #{description}"
end

# Generate your own layout and paste posts in it
# Don't forget to change text and name =)
markdown = <<~EOF
# Hi there 👋

I am a Software Engineer focused on building scalable backend systems and managing cloud-native infrastructure. Currently, I am deepening my expertise in the Cloud Native ecosystem and self-hosting.

## Tech Stack & Tools

- **Backend:** PHP (Laravel), Go, Rust
- **Infrastructure:** Docker, OpenWrt
- **DevOps / Networking:** Tailscale, VPNs, CI/CD Pipelines
- **Storage & Media:** Jellyfin, Home Assistant, Pi-hole

## My Homelab Journey

I'm passionate about self-hosting and running my own infrastructure. My current setup runs on a **ThinkCentre M720q** (Intel i5-8500T, 16GB RAM), where I experiment with:

- Containerizing services for home automation and network security
- Managing private networking with Tailscale and OpenWrt

## Currently Working On

- Optimizing Docker workloads and troubleshooting high-concurrency queue systems
- Fine-tuning homelab power efficiency and network stability


![counter](https://ene3oosohyebu4a.m.pipedream.net)


## My Latest Repositories

#{posts.join("\n")}
EOF

# Write you markdown to README.MD
File.write("./README.md", markdown)
