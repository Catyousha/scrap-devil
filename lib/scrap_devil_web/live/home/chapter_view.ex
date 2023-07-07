defmodule ScrapDevilWeb.Live.Home.ChapterView do
  use ScrapDevilWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" phx-click="back_to_home">Back</button>
      <%= for image <- @current_images do%>

      <% src = ~w"/#{image}" %>
        <img src={src}>
      <% end %>
    </div>
    """
  end
end
