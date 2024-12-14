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
        <.banner>
          <.icon name="hero-sparkles-solid" />
          Mystery Raffle Coming Soon!!
          <:details :let={vibe}>
            To Be Revealed Tomorrow <%= vibe %>
          </:details>
          <:details>
            Any guesses?
          </:details>
        </.banner>
        <div class="raffles">
          <.raffle_card :for={raffle <- @raffles} raffle={raffle} />
        </div>
      </div>
    """
  end

  slot :inner_block, required: true
  slot  :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~w(🥸 🤩 🥳) |> Enum.random())

    ~H"""
      <div class="banner">
        <h1>
          <%= render_slot(@inner_block) %>
        </h1>
        <div :for={details <- @details} class="details">
          <%= render_slot(details, @emoji) %>
        </div>
      </div>
    """
  end

  attr :raffle, Rafflefy.Raffles.Raffle, required: true

  def raffle_card(assigns) do
    ~H"""
      <.link navigate={~p"/raffles/#{@raffle}"}>
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
      </.link>
    """
  end
end
