defmodule RafflefyWeb.RaffleLive.Index do
  use RafflefyWeb, :live_view

  import RafflefyWeb.CustomComponents
  alias Rafflefy.Raffles

  def mount(_params, _session, socket) do
    socket = assign(socket, :raffles, Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner />
      <div class="raffles">
        <.raffle_card :for={raffle <- @raffles} raffle={raffle} />
      </div>
    </div>
    """
  end

  def banner(assigns) do
    ~H"""
      <div class="banner">
        <h1>
          <.icon name="hero-sparkles-solid" />
          Mystery Raffle Coming Soon!!
        </h1>
      </div>
    """
  end

  attr :raffle, Rafflefy.Raffle, required: true

  def raffle_card(assigns) do
    ~H"""
      <div class="card">
        <img src={@raffle.image_path} />
        <h2><%= @raffle.prize %></h2>
        <div class="details">
          <div class="price">
            $<%= @raffle.ticket_price %> / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </div>
    """
  end
end
