defmodule ScrapDevil.Fetchers.HTTPoisonFetcher do
  @behaviour Crawly.Fetchers.Fetcher

  require Logger

  def fetch(request, _client_options) do
    options = case (System.get_env("USING_TOR") || "false") do
      "true" -> [
        {:proxy, {:socks5, 'localhost', 9150}},
        {:recv_timeout, 360_000}
      ]
      "false" -> []
    end

    HTTPoison.get(
      request.url,
      request.headers,
      request.options ++ options
    )
  end
end
