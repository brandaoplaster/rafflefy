defmodule RafflefyWeb.Live.RaffleLive.Show do
  use RafflefyWeb, :live_view

  alias Rafflefy.Raffles

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    raffle = Raffles.get_raffle(id)

    socket =
      socket
      |> assign(:raffle, raffle)
      |> assign(:page_title, raffle.prize)

    {:noreply, socket}
  end
end
