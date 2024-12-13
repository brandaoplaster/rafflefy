defmodule RafflefyWeb.Live.RaffleLive.Show do
  use RafflefyWeb, :live_view

  import RafflefyWeb.CustomComponents

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

  def render(assigns) do
    ~H"""
      <div class="raffle-show">
        <div class="raffle">
          <img src={@raffle.image_path} />
          <section>
            <.badge status={@raffle.status} />
            <header>
              <h2><%= @raffle.prize %></h2>
              <div class="price">
                $<%= @raffle.ticket_price %> / ticket
              </div>
            </header>
            <div class="description">
              <%= @raffle.description %>
            </div>
          </section>
        </div>
        <div class="activity">
          <div class="left"></div>
          <div class="right">
          </div>
        </div>
      </div>
    """
  end
end
