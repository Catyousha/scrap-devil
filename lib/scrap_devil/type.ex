defmodule ScrapDevil.Type do
  @type chapter :: %{
    title: String.t(),
    url: String.t(),
    number: integer(),
    images: list(String.t())
  }
end
