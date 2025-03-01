defmodule RafflefyWeb.EstimatorLive do
  use RafflefyWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    {:ok, assign(socket, tickets: 0, price: 3)}
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    socket = update(socket, :tickets, &(&1 + String.to_integer(quantity)))

    {:noreply, socket}
  end

  def handle_event("set_price", %{"price" => price}, socket) do
    socket = assign(socket, :price, String.to_integer(price))

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :tickets, &(&1 + 10))}
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

        <form phx-submit="set_price">
          <label for="price">Ticket Price</label>
          <input type="number" name="price" value={@price} />
        </form>
      </div>
    """
  end
end
