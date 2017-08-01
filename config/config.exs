# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :once,
  ecto_repos: [Once.Repo]

# Configures the endpoint
config :once, Once.Endpoint,
  secret_key_base: "fCaHY2Y7IoZdYGnki08OHVXGMwyebhQk5HapTC2LeBJ61Z+dPsJf7c54lNDTIBhr",
  render_errors: [view: Once.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Once.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
