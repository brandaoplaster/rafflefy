defmodule RafflefyWeb.EstimatorLive do
  use RafflefyWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, tickets: 0, price: 3)}
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    socket = update(socket, :tickets, &(&1 + String.to_integer(quantity)))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="estimator">
        <h1>Rafflefy Estimator</h1>
        <section>
          <button phx-click="add" phx-value-quantity="5">
            +
          </button>
          <div>
            <%= @tickets %>
          </div>
          @
          <div>
            $<%= @price %>
          </div>
          =
          <div>
          $<%= @tickets * @price %>
          </div>
        </section>
      </div>
    """
  end
end
