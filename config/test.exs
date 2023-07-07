import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# We don't run a server during test. If one is required,
# you can enable the server option below.
config :scrap_devil, ScrapDevilWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oDNDHojN0zBTj7ZTj+sIIyE6EgP2A4VNvw8M6am/MxXdQuRM0qLLV3n+DfH68bok",
  server: false

# In test we don't send emails.
config :scrap_devil, ScrapDevil.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
