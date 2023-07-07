import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :scrap_devil, ScrapDevilWeb.Endpoint,
  server: true,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  cache_static_manifest: "priv/static/cache_manifest.json",
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/scrap_devil_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: ScrapDevil.Finch

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

config :crawly,
  closespider_itemcount: 1000,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
  fetcher: {ScrapDevil.Fetchers.HTTPoisonFetcher, []},
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    Crawly.Middlewares.AutoCookiesManager,
    {
      Crawly.Middlewares.UserAgent,
      user_agents: [
        "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36 OPR/38.0.2220.41"
      ]
    }
  ]