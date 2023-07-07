defmodule ScrapDevil do
  def fetch_chapters do
    GenServer.call(ScrapDevil, {:all}, 360_000)
  end

  def fetch_chapter_pages(number) do
    GenServer.call(ScrapDevil, {:chapter, number}, 360_000)
  end
end
