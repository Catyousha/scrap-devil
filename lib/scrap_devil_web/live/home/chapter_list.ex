defmodule ScrapDevilWeb.Live.Home.ChapterList do
  use ScrapDevilWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div class="text-black text-lg font-medium mx-24 mb-16">“Websites fear scrappers with a few screws loose.”<br/>- Kishibe (probably)</div>
        <div class="flex-col justify-start items-start gap-2.5 inline-flex pb-10">
          <div class="justify-start items-center gap-3 inline-flex">
            <div class="w-[22px] h-[21px] bg-green-300 rounded-md"></div>
            <div class="text-black text-sm font-normal">Scrapped</div>
          </div>
          <div class="justify-start items-center gap-3 inline-flex">
            <div class="w-[22px] h-[21px] bg-neutral-300 rounded-md"></div>
            <div class="text-black text-sm font-normal">Not scrapped yet, may take a while when opens</div>
          </div>
        </div>
        <div class="grid grid-cols-12 gap-4">
        <%= for chapter <- @chapters do%>
        <div
          phx-click="view"
          phx-value-key={chapter.number}
          class={"md:col-span-2 sm:col-span-6 col-span-12 p-2.5 #{bg(chapter.images)} hover:bg-yellow-50 rounded shadow flex-col justify-start items-start gap-3 inline-flex"}>
          <div class="text-zinc-800 text-[18px] font-bold">Chapter <%= chapter.number %></div>
          <div class="text-zinc-800 text-[18px] font-normal"><%= chapter.title %></div>
        </div>
        <% end %>
      </div>
    </div>
    """
  end

  def bg(images) do
    case images do
      [] -> "bg-neutral-100"
      _ -> "bg-green-200"
    end
  end
end
