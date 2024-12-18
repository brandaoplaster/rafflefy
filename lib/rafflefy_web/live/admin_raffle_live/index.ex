defmodule RafflefyWeb.AdminRaffleLive.Index do
  use RafflefyWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Raffles")

    {:ok, socket}
  end
end
