# ./scripts/rb/update_readme.rb
require "json"
require "faraday"

USERNAME = ENV.fetch("GITHUB_USERNAME", "metagenes")
REPO_LIMIT = Integer(ENV.fetch("REPO_LIMIT", "5"), 10)

connection = Faraday.new(url: "https://api.github.com") do |conn|
  conn.request :url_encoded
  conn.adapter Faraday.default_adapter
  conn.options.timeout = 10
end

response = connection.get("/users/#{USERNAME}/repos", { sort: "updated", per_page: REPO_LIMIT }) do |req|
  req.headers["Accept"] = "application/vnd.github+json"
  req.headers["X-GitHub-Api-Version"] = "2022-11-28"
  req.headers["User-Agent"] = "#{USERNAME}-readme-updater"
end

unless response.success?
  warn "GitHub API request failed with status #{response.status}"
  warn response.body.to_s[0..500]
  exit 1
end

repos = JSON.parse(response.body)

posts = repos.map do |repo|
  description = repo["description"]&.strip
  description = "No description available." if description.nil? || description.empty?

  "- [#{repo['name']}](#{repo['html_url']}) — #{description}"
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

# Write markdown to README.md
readme_path = File.expand_path("../../README.md", __dir__)
File.write(readme_path, markdown)
