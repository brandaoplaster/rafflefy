defmodule RafflefyWeb.RaffleLive.Index do
  use RafflefyWeb, :live_view

  import RafflefyWeb.CustomComponents
  alias Rafflefy.Raffles

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.list_raffles())
      |> assign(:form, to_form(%{}))
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

        <.form for={@form}>
          <.input field={@form[:q]} placeholder="Search" autocomplete="off" />
          <.input
            type="select"
            field={@form[:status]}
            prompt="Status"
            options={[:upcoming, :open, :closed]}
          />
          <.input
            type="select"
            field={@form[:sort_by]}
            prompt="Sort By"
            options={[:prize, :ticket_price]}
          />
        </.form>

        <div class="raffles" id="raffles" phx-update="stream">
          <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
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
  attr :id, :string, required: true

  def raffle_card(assigns) do
    ~H"""
      <.link navigate={~p"/raffles/#{@raffle}"} id={@id} >
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
