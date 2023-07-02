import Config

config :issues,
  github_url: System.fetch_env!("GITHUB_URL")
