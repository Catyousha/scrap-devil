defmodule ScrapDevilWeb.Live.Home do
  use ScrapDevilWeb, :live_view

  def mount(_params, _session, socket) do
    chapters = ScrapDevil.fetch_chapters()

    socket =
      socket
      |> assign(%{
        chapters: chapters,
        current_images: "",
      })

    {:ok, socket}
  end

  def handle_event("view", %{"key" => num}, socket) do
    {num, _} = Integer.parse(num)
    {images, chapters} = ScrapDevil.fetch_chapter_pages(num)
    {:noreply, assign(socket, current_images: images, chapters: chapters)}
  end

  def handle_event("back_to_home", _key, socket) do
    {:noreply, assign(socket, :current_images, "")}
  end

  def render(%{current_images: "", chapters: chapters} = assigns) do
    ~L"""
    <%= live_component(__MODULE__.ChapterList, chapters: chapters, id: 1 )%>
    """
  end

  def render(assigns) do
    ~L"""
    <%= live_component(__MODULE__.ChapterView, current_images: assigns.current_images, id: 1 )%>
    """
  end
end
