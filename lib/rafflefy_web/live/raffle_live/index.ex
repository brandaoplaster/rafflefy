defmodule RafflefyWeb.RaffleLive.Index do
  use RafflefyWeb, :live_view

  import RafflefyWeb.CustomComponents
  alias Rafflefy.Raffles

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
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

        <.filter_form form={@form} />

        <div class="raffles" id="raffles" phx-update="stream">
          <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
        </div>
      </div>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/raffles?#{params}")

    {:noreply, socket}
  end

  def filter_form(assigns) do
    ~H"""
      <.form for={@form} phx-change="filter" id="filter-form">
        <.input field={@form[:q]} placeholder="Search" autocomplete="off" phx-debounce="500" />
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
          options={[
            Prize: "prize",
            "Price: High to Low": "ticket_price_desc",
            "Price: Low to High": "ticket_price_asc"
          ]}
        />

        <.link patch={~p"/raffles"}>
          Reset
        </.link>
      </.form>
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
