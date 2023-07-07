defmodule ScrapDevil.Core.Impl.Scrapper do
  alias ScrapDevil.Type

  @base_url "https://tcbscans.com"
  @manga_url "https://tcbscans.com/mangas/13/chainsaw-man"

  @spec get_all_chapters :: list(Type.chapter())
  def get_all_chapters do
    response = Crawly.fetch(@manga_url)
    {:ok, document} = Floki.parse_document(response.body)
    priv_dir = :code.priv_dir(:scrap_devil)

    document
    |> Floki.find("a.bg-card")
    |> Enum.map(fn a ->
      chapter_num =
        Floki.find(a, ".text-lg")
        |> Floki.text()
        |> String.replace(~r/[^\d]/, "")
        |> String.to_integer()

      %{
        url:
          Floki.attribute(a, "href")
          |> Floki.text()
          |> concat_base_url(),
        title:
          Floki.find(a, ".text-gray-500")
          |> Floki.text(),
        number: chapter_num,
        images:
          Path.wildcard("#{priv_dir}/uploads/csm/#{chapter_num}_*")
          |> Enum.map(fn x -> String.replace(x, "#{priv_dir}/", "") end)
      }
    end)
  end

  @spec get_chapter_images(integer(), String.t()) :: list(String.t())
  def get_chapter_images(chapter_number, chapter_url) do
    response = Crawly.fetch(chapter_url)
    {:ok, document} = Floki.parse_document(response.body)

    document
    |> Floki.find("picture img")
    |> Floki.attribute("src")
    |> Enum.with_index()
    |> Flow.from_enumerable()
    |> Flow.map(fn {url, index} ->
      page_num = padded_num(index + 1)
      dl_path = "uploads/csm/#{chapter_number}_#{page_num}.jpg"
      filepath = "#{:code.priv_dir(:scrap_devil)}/#{dl_path}"
      img = Crawly.fetch(url)
      File.write(filepath, img.body)
      dl_path
    end)
    |> Enum.to_list()
  end

  @spec concat_base_url(String.t()) :: String.t()
  def concat_base_url(url) do
    "#{@base_url}#{url}"
  end

  @spec padded_num(integer()) :: String.t()
  def padded_num(num) do
    num
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
  end
end
