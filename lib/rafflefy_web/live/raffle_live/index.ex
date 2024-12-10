defmodule RafflefyWeb.RaffleLive.Index do
  use RafflefyWeb, :live_view

  alias Rafflefy.Raffles

  def mount(_params, _session, socket) do
    socket = assign(socket, :reffles, Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <div class="raffles">
        <div :for={raffle <- @raffles} class="card">
          <img src={raffle.image_path} />
          <h2><%= raffle.prize %></h2>
          <div class="details">
            <div class="price">
              $<%= raffle.ticket_price %> / ticket
            </div>
            <div class="badge">
              <%= raffle.status %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
