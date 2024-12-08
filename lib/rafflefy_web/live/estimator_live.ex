defmodule RafflefyWeb.EstimatorLive do
  use RafflefyWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, tickets: 0, price: 3)}
  end
  
  def render(assigns) do
    ~H"""
      <div class="estimator">
        <h1>Rafflefy Estimator</h1>
        <section>
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
