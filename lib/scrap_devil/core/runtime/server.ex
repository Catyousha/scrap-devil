defmodule ScrapDevil.Core.Runtime.Server do
  alias ScrapDevil.Core.Impl.Scrapper
  alias ScrapDevil.Type
  @type t :: pid()

  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: ScrapDevil)
  end

  @spec init(any) :: {:ok, Type.chapter()}
  def init(_init_arg) do
    {:ok, Scrapper.get_all_chapters()}
  end

  def handle_call({:all}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:chapter, number}, _from, state) do
    new_state =
      Enum.map(state, fn
        %{number: ^number} = chapter -> get_cached_chapter(chapter)
        chapter -> chapter
      end)

    images = Enum.find(new_state, fn chapter -> chapter.number == number end).images

    {:reply, {images, new_state}, new_state}
  end

  @spec get_cached_chapter(Type.chapter()) :: Type.chapter()
  defp get_cached_chapter(%{images: []} = chapter) do
    
    %{
      chapter
      | images:
          get_locals_or_scrap_img(
            Path.wildcard("priv/uploads/csm/#{chapter.number}_*"),
            chapter.number,
            chapter.url
          )
    }
  end

  defp get_cached_chapter(chapter), do: chapter

  @spec get_locals_or_scrap_img(list(String.t()), integer(), String.t()) :: list(String.t())
  defp get_locals_or_scrap_img([], chapter_number, chapter_url) do
    Scrapper.get_chapter_images(chapter_number, chapter_url)
  end

  defp get_locals_or_scrap_img(locals, _num, _url) do
    Enum.map(locals, fn x -> String.replace(x, "priv/", "") end)
  end
end
