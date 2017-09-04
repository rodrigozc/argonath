# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :argonath,
  ecto_repos: [Argonath.Repo]

# Configures the endpoint
config :argonath, Argonath.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WPKMRrd5cIrStaiO1erZu9pW8j1I10gyXzrtU2hy4NR1mgf8U790m9liCIfWqTHP",
  render_errors: [view: Argonath.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Argonath.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
