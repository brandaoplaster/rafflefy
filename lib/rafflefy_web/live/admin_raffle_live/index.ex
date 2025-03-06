defmodule RafflefyWeb.AdminRaffleLive.Index do
  use RafflefyWeb, :live_view

  import RafflefyWeb.CustomComponents
  alias Rafflefy.Raffles

  on_mount {RafflefyWeb.UserAuth, :ensure_authenticated}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Raffles")
      |> stream(:raffles, Raffles.list_raffles())

    {:ok, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Raffles.get_raffle(id)
    {:ok, _} = Raffles.delete_raffle(raffle)

    {:noreply, stream(socket, :reffles, raffle)}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        <%= @page_title %>
        <:actions>
          <.link navigate={~p"/admin/raffles/new"} class="button">
            New Raffle
          </.link>
        </:actions>
      </.header>
      <.table id="raffles" rows={@streams.raffles}>
        <:col :let={{_dom_id, raffle}} label="Prize">
          <.link navigate={~p"/raffles/#{raffle}"}>
            <%= raffle.prize %>
          </.link>
        </:col>
        <:col :let={{_dom_id, raffle}} label="Status">
          <.badge status={raffle.status} />
        </:col>
        <:col :let={{_dom_id, raffle}} label="Ticket Price">
          <%= raffle.ticket_price %>
        </:col>
        <:action :let={{_dom_id, raffle}}>
          <.link navigate={~p"/admin/raffles/#{raffle}/edit"}>
            Edit
          </.link>
        </:action>
        <:action :let={{_dom_id, raffle}}>
          <.link phx-click="delete" phx-value-id={raffle.id} data-confirm="Are you sure?">
            Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end
end
